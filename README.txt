README:

1.   The first 112 lines of the code contains all functions that are used in the program.
2.   In line 117, type the path where the dataset (Easy, Hard or Wine) can be found in your computer. 
3.   In line 120, type the directory where you want the final output (.csv) to be stored.
4a . If you are using the Easy or hard dataset, make sure line 124 is uncommented and lines 129 and 130 are commented.
4b.  If you are using the Wine dataset, make sure line 124 is commented and lines 129 and 130 are uncommented.
	(These will pre-process the corresponding datasets).
5.   In lines 133 and 134, set the required values for k and the maximum number of iterations respectively.
6.   Run line 138 to run the clustering algorithm. This dataset will have the cluster assignments of each datapoint for each iteration. 
     The last column of this dataframe contains the distance between the datapoint and its cluster center.
7.   Run lines 141 to 145 to get the results of the clustering in the required format stored in the 'results' data frame.
8.   If you want the silhouette widths for each point, run line 149. The resulting dataframe will have the information.
9.   Running lines 152 and 153 will give you the dataframe with the average silhouette widths for each cluster.
10.  Finally, running line 156 will save the 'results' dataframe in csv format in the directory specified in 3.

Thanks! :)