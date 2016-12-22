# function that calcultes the Euclidean distance between 2 points
euclid <- function(a, b) {
  
  dist=0
  for (n in 1:ncol(a))
  {
    dist = dist + ((a[1,n]-b[1,n])*(a[1,n]-b[1,n]))  
  }
  dist=as.numeric(sqrt(dist))
  dist
}

#function that generates a random centroid within the range of the corresponding column in the dataset
random <- function(data){
  rand = data.frame()
  for(n in 1:ncol(data)){
    rand[1,n] = runif(1, min(data[,n]), max(data[,n]))  
  }
  rand
}

# function that generates k random centroids for the first iteration
centroid_gen <- function(k, data){
  centroid = data.frame()
  for(i in 1:k){
    centroid= rbind(centroid,random(data))
  }
  centroid
}

# function that does the K means clustering
kMeansClustering <- function(data,k,iter){
  
  centroid_curr = centroid_gen(k, data) # gets the inital k centroids (randomly generated)
  cluster = data.frame()
  
  # loop over the max number of iterations allowed
  for(num in 1:iter){
    change =0 # this tracks the total number of changes from the previous iteration (used for detecting convergence)
    
    # if number of clusters assigned is less than k, go back to the previous iteration and start over
    # (this solves the empty cluster problem)
        if(num > 1 && length(unique(cluster[,num-1]))!=k){
          num = num-1
        }
    #loop for each data point
    for (i in 1:nrow(data)){
      euc = data.frame() # this stores the distance of the current point from each centroid
      for(j in 1:k){
        euc[1,j] = euclid(centroid_curr[j,], data[i,])  
      }
      # the cluster number of the centroid that has minimum distance is assigned to this data point
      cluster[i,num]=as.matrix(apply(euc,1, which.min))[1]
      
      # tracks the number of changes from the previous iteration
      if((num!=1) && (cluster[i,num]!=cluster[i,num-1])) change=change+1
    }
    
    # stop if there are no changes (convergence)
    if ((num!=1)&&(change==0)) break
    
    # reset the cluster centers for the next iteration
    for(j in 1:k){
      for(t in 1:ncol(data)){
        centroid_curr[j,t]=aggregate( data[,t] ~ cluster[,num], data, mean )[j,2]
      }
    }
  }
  # add the distances of each data point with its final centroid to the dataset that is being returned
  for(s in 1:nrow(cluster)){
    cluster[s,num+1] = euclid(centroid_curr[cluster[s,num],],data[s,])  
  }
  cluster
}

# this function caculates the silhouette width for each data point

sil_calc <- function(results, data){
  sil = data.frame()
  
  #loop for each data point
  for(i in 1:nrow(results)){
    count = 1
    count2 = 1
    aData = c() # holds the distance between the current datapoint and all other data points in every other cluster
    bData = c() # holds the distance between the current datapoint and all other points in the same clusters
    
    #loop for every other data point
    for (j in 1:nrow(results)){
      if(1!=j){
        # if the 2 points belong to the same cluster, put their distance in bData
        if(results[i,2]==results[j,2]){
          bData[count] = euclid(data[i,],data[j,])
          count=count+1
        }
        # if the 2 points does not belong to the same cluster, put their distance in aData
        else{
          aData[count2] = euclid(data[i,],data[j,])
          count2=count2+1
        }
      }
    }
    sil[i,1] = mean(bData) # for this point, save the mean of bData in the final dataframe
    sil[i,2] = min(aData) # for this point, save the min of aData in the final dataframe
  }
  # calculate the silhouette width for each data point
  for(i in 1:nrow(sil)){
    sil[i,3] = (sil[i,1] - sil[i,2])/(min(sil[i,1],sil[i,2]))  
  }
  colnames(sil) = c("a", "b", "silhouette width")
  sil
}

######## #void main equivalent ############

# set the path to the required dataset accordinly
dataset = read.csv("C:/Users/arjhu_000/Dropbox/OSU/Grad materials/Fall 2016/CSE 5243/Datasets/TwoDimHard.csv")

#set the location for the final result to be stored
setwd("C:/Users/arjhu_000/Dropbox/OSU/Grad materials/Fall 2016/CSE 5243/Datasets/")

# comment below line if you are using the wine dataset 
# (this is the data preparation for Easy and Hard datasets)
finalData = dataset[,2:3]

# uncomment below 2 lines for the wine dataset
# (this is the data preparation for the wine dataset)

#finalData= dataset[,2:ncol(dataset)]
#finalData = finalData[,1:ncol(finalData)-1]


k = 4   # set the number of clusters
iter = 25 # set the maximum number of iterations, if no convergence occurs

# gives the allocation of clusters for each data point for each iteration. Last column is 
# the distance of each of the data points from its cluster centers.
clusters= kMeansClustering(finalData,k,iter)

# final result
results = as.data.frame(cbind(dataset[,1], clusters[,ncol(clusters)-1]))
#results = cbind(results,dataset[,ncol(dataset)])
#results = cbind(results,clusters[,ncol(clusters)])
#colnames(results) = c("ID","Pred Cluster", "Actual Cluster","Distance")
colnames(results) = c("ID","Pred Cluster")


# calculates the silhouette widths for each of the data points
silData = sil_calc(results,finalData)

# gives the average silhouette width for each cluster
aveSil = aggregate( silData[,3] ~ results[,2], silData, mean )
colnames(aveSil) = c("Cluster", "Avg Sil width")

# write the results to a csv file
write.csv(results,"results.csv")
