# define the coefficienct of x for given equation(ax + b + N(0,sd))
trueA <- 5
# define the intercept for given equation(ax + b + N(0,sd))
trueB <- 0
# define the standard deviation of normal distribution for generate randome noise
trueSd <- 10
# define number of sample size
sampleSize <- 31

# create independent x-values
# create a vector of values from -(n-1)/2 to (n-1)/2 with n as sample size
x <- (-(sampleSize-1)/2):((sampleSize-1)/2)
# create dependent values according to ax + b + N(0,sd)
# create a vector of values applying previously defined trueA, x, trueB and
# a random number generated from normal distribution trueSd as standard deviation
# to a given linear equation (ax + b + N(0,sd))
y <-  trueA * x + trueB + rnorm(n=sampleSize,mean=0,sd=trueSd)
# plot the graph with x and y with the title as "Test Data"
plot(x,y, main="Test Data")

# define function to get liklihood and it takes the parameters (a, b, sd) as an input, 
# and return the probability of obtaining the test data above under this model 
likelihood <- function(param){
  # assign a as the first element of param and it will the coefficient of x
  a = param[1]
  # assign b as the second element of param and it will the y-intercept
  b = param[2]
  # assign c as the third element of param and it will the standard deviation
  sd = param[3]
  
  # define pred as the predictied value applying a and b to the previously 
  # defined sample vector 
  pred = a*x + b
  # create a vector of log(probability) that follows the normal distribution 
  # with mean equal to pred and standard deviation equal to sd and here, probability is density
  singlelikelihoods = dnorm(y, mean = pred, sd = sd, log = T)
  # sum all the values in singlelikelihoods
  # (we work with the sum because we work with logarithms.)
  sumll = sum(singlelikelihoods)
  # return sumll
  return(sumll)   
}

# Example: plot the likelihood profile of the slope a
# define function take x as input and returns the probablity using likelihood function 
# take x, trueB, trueSd as input 
slopevalues <- function(x){return(likelihood(c(x, trueB, trueSd)))}
# assign the values from applying slopevalues function into given sequence to slopelikelihoods 
slopelikelihoods <- lapply(seq(3, 7, by=.05), slopevalues )
# plot the graph with slopelikelihoods and sequence and type of plot is line
# with x lable as "values of slope parameter a" and y lable as "Log likelihood"
plot (seq(3, 7, by=.05), slopelikelihoods , type="l", xlab = "values of slope parameter a", ylab = "Log likelihood")

# Prior distribution
# define function to get a prior distribution for each parameters 
prior <- function(param){
  # assign a as the first element of param
  a = param[1]
  # assign b as the second element of param
  b = param[2]
  # assign sd as the third element of param
  sd = param[3]
  # create a vector of log(probability) that follows the uniform distribution of "a"
  # on the interval from min to max, here probability is density
  aprior = dunif(a, min=0, max=10, log = T)
  # create a vector of log(probability) that follows the normal distribution of "b"
  # with given sd and here, probability is density
  bprior = dnorm(b, sd = 5, log = T)
  # create a vector of log(probability) that follows the uniform distribution of "sd"
  # on the interval from min to max, here probability is density
  sdprior = dunif(sd, min=0, max=30, log = T)
  # return the sum of aprior, bprior and sdprior
  # (we work with the sum because we work with logarithms.)
  return(aprior+bprior+sdprior)
}
# posteriot function
# define function to get a posterior distribution 
posterior <- function(param){
  # return the sum of the results of likelihood and prior functions using param as input
  # sum of likelihood probability and prioir probability 
  # (we work with the sum because we work with logarithms.)
  return (likelihood(param) + prior(param))
}


######## Metropolis algorithm ################
# define function that returns random numbers that follow normal distribution
# with mean as param and given sd with param as input
proposalfunction <- function(param){
  # return random number that follow normal distribution with given arguments
  return(rnorm(3,mean = param, sd= c(0.1,0.5,0.3)))
}
# define function for executing M-H function, take startvalue as input for starting point
# and interations as the number of interation that we want to execute
run_metropolis_MCMC <- function(startvalue, iterations){
  # assign chain as an (iterations +1) x 3 matrix with empty values 
  chain = array(dim = c(iterations+1,3))
  # assign startvalue to the first row of the chain matrix
  chain[1,] = startvalue
  # loop over from 1 to iterations (iterations times)
  for (i in 1:iterations){
    # get proposal vector using proposalfunction by inputting i-th row from the chain matrix
    proposal = proposalfunction(chain[i,])
    # get probab vector using posterior function to calculate the ratio between proposal 
    # and the values of i-th rows and take exponential of the result (note that, (p1/p2 = exp[log(p1)-log(p2)))
    # and this is acceptance probability
    probab = exp(posterior(proposal) - posterior(chain[i,]))
    
    # if random number that follow uniform distribution between 0 and 1 is 
    # less than probab(acceptance probability), then proposal vector will asssign 
    # to i+1-th row of the chain matrix
    if (runif(1) < probab){
      chain[i+1,] = proposal
    # if not, i-th row of the chain matrix will assign to the i+1-th row of chain matrix
    }else{
      chain[i+1,] = chain[i,]
    }
  }
  # return the chain matrix
  return(chain)
}

# define startvalue vector
startvalue = c(4,0,10)
# execute run_metropolis_MCMC function input as startvalue and 10000 iteration times
# and assign the return value(matrix) to chain 
chain = run_metropolis_MCMC(startvalue, 10000)

# define burnIn as 5000
burnIn = 5000
# define accpetance vector as 1 - mean of the chain metrix that exclude 1st rows 
# to burnIn-th rows of the chain matrix
acceptance = 1-mean(duplicated(chain[-(1:burnIn),]))

### Summary: #######################
# generate 2x3 array of graphs
par(mfrow = c(2,3))
# draw histogram with the 1st row of the chain matrix and the number of bis is 30
# and title is "Posterior of a" and x-lable is "True value = red line"
hist(chain[-(1:burnIn),1],nclass=30, , main="Posterior of a", xlab="True value = red line" )
# draw a vertical line to the histogram at the mean of elements in chain[-(1:burnIn),1]
abline(v = mean(chain[-(1:burnIn),1]))
# draw a red vertical line at the trueA 
abline(v = trueA, col="red" )
# draw histogram with the 2nd row of the chain matrix and the number of bis is 30
# and title is "Posterior of b" and x-lable is "True value = red line"
hist(chain[-(1:burnIn),2],nclass=30, main="Posterior of b", xlab="True value = red line")
# draw a vertical line to the histogram at the mean of elements in chain[-(1:burnIn),2]
abline(v = mean(chain[-(1:burnIn),2]))
# draw a red vertical line at the trueB
abline(v = trueB, col="red" )
# draw histogram with the 2nd row of the chain matrix and the number of bis is 30
# and title as "Posterior of sd" and x-lable as "True value = red line"
hist(chain[-(1:burnIn),3],nclass=30, main="Posterior of sd", xlab="True value = red line")
# draw a vertical line to the histogram at the mean of elements in chain[-(1:burnIn),3]
abline(v = mean(chain[-(1:burnIn),3]) )
# draw a red vertical line at the trueSd
abline(v = trueSd, col="red" )

# draw plot with the 1st row of the chain matrix and the number of bis is 30
# type is line and title is "Chain values of a" and x-lable is "True value = red line"
plot(chain[-(1:burnIn),1], type = "l", xlab="True value = red line" , main = "Chain values of a", )
# draw a red horizontal line at the trueA
abline(h = trueA, col="red" )
# draw plot with the 1st row of the chain matrix and the number of bis is 30
# type is line and title is "Chain values of b" and x-lable is "True value = red line"
plot(chain[-(1:burnIn),2], type = "l", xlab="True value = red line" , main = "Chain values of b", )
# draw a red horizontal line at the trueB
abline(h = trueB, col="red" )
# draw plot with the 1st row of the chain matrix and the number of bis is 30
# type is line and title is "Chain values of sd" and x-lable is "True value = red line"
plot(chain[-(1:burnIn),3], type = "l", xlab="True value = red line" , main = "Chain values of sd", )
# draw a red horizontal line at the trueSd
abline(h = trueSd, col="red" )

# for comparison:
# get summary of the linear regression model with dependent variable as y 
# and independent variable as x
summary(lm(y~x))
