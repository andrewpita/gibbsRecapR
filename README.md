# gibbsRecapR

### Overview

gibbsRecapR consists of four functions that allow for Bayesian analysis of capture-recapture data using the gibbs sampler described in Bayesian Multi-Region Size Esimtation of HIV Key Popylations in Eswatini Using Incomplete and Misaligned Capture-Recapture Data (cite).  While the gibbs sampler described in that paper generalizes fully to any number of data sources, at the moment these functions can account for only 2 or 3 sources, and only the case of incompleteness.  

### Functions

The functions betahyperMH() and postlike() are used within the gibbs_chain() function, and as such will most likely not be used by the package user. Both of these functions are involved in the Metropolis-Hastings update of the hyperparameters belonging to the Beta prior placed on the overal key population proportion.  

loc_update() is also used within the gibbs_chain function, but it's conceivable that a user would want to use the function as a stand alone function. This function updates the parameters for a single location. 

gibbs_chain() is the primary workhouse function of the package, creating a chain of posterior draws for all relevant parameters of interest.  

### Context of the Data

The setting for this type of analysis is one in which capture-recapture type data using multiple sources (commmonly referred to as the multiplier method) has been collected at various locations within a given geographical unit.  In the case of the paper referred to above, multiplier method data was collected in 5 locations within the country of eSwatini.  As such, the input data for gibbs_chain() is somewhat complicated and requires that the user follow a specific format.  

### gibbs_chain()

The first required input for gibbs_chain() is a list of the relevant data (dataList), where each element of the dataList is a location specific list containing that locations data in a precise format.  The second required input is a seed.  All other inputs are either optional or set by default.  Full details are available in the help documentation within R (?gibbs_chain). 

The location specific list consists of elements that must be within this format and order:

* a dataframe consisting of of three columns.  The first column contains the marginal totals for each of the data sources, with the first being the survey.  The second column contains the overlaps between the survey and the other sources, such that the overlap between the survey and source B is in the same row as the marginal total of source B in column 1.  The number of subjects within all sources and the survey is placed in the same row (row 1) as the marginal total of survey participants. The third column contains an arbitrary initial vector of inclusion probabilities for each source. 

* The second element of the list is an arbitary initial starting value for the total number of key population members in this location. 

* The third element is the total number of people within this location who meet the inclusion criteria for participating in the survey, aside from key population member status.  In other words, if to participate in the survey one had to be older than 18, female, and gained income from sex work in the last year, than this number is the total number of females older than 18 in the general population. 

* The fourth and fifth elements respectively are the alpha and beta values for the Beta prior placed on the inclusion probabilities. 

* The sixth element is an arbitary initial starting value for the key population proportion in this location. 

parnames is an optional input argument to gibbs_chain() that will provide column names for the matrix containing chain that is output by the function.  This vector of parameter names must be in the same order as the information passed within each element of dataList.  For example if the first element of dataList contains a dataframe with data sources in column in the order of survey, source B, and source C, then parnames would consist of the name for the inclusion probability for the survey, the inclusion probability for source B, the inclusion probability for source C, the parameter name for the number of key population members at that location, and the parameter name for the key population proportion in that location.  This would continue for each element of dataList, with the requirement that the final two parameter names refer to the alpha and beta hyper-parameters belonging to the Beta prior placed on the overall key population proportion. 
