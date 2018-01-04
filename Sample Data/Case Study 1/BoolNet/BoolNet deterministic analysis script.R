library("BoolNet")
library("tictoc")

# Loading Network
net <- loadNetwork("Yeast Cell Cycle Network BoolNet Input.txt")

# Network Sketching
tic()
plotNetworkWiring(net)
toc()

# Deterministic Analysis - Finding Attractors
tic()
attr <- getAttractors(net,canonical = FALSE, method = 'exhaustive')
toc()

n = 11; # Number of nodes

# Probabilistic Analysis - numIterations = n
tic()
sim <- markovSimulation(net, numIterations = n, returnTable = FALSE)
toc()


# Probabilistic Analysis - RECOMMENDED numIterations = 2^n
tic()
sim <- markovSimulation(net, numIterations = 2^n, returnTable = FALSE)
toc()







