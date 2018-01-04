library("BoolNet")
library("tictoc")


# 1. Control
control <- loadNetwork("Control (0).txt")
attr <- getAttractors(control, canonical = FALSE)

# 2. Wip1
Wip1 <- loadNetwork("0_Wip1.txt")
attr <- getAttractors(Wip1, canonical = FALSE)

# 3. Nutlin
Nutlin <- loadNetwork("0_Nutlin.txt")
attr <- getAttractors(Nutlin, canonical = FALSE)

# 4. Nultin + Wip1
Nutlin_Wip1 <- loadNetwork("0_Nutlin_Wip1.txt")
attr <- getAttractors(Nutlin_Wip1, canonical = FALSE)

# 5. Etoposide
Etoposide <- loadNetwork("Etoposide (1).txt")
attr <- getAttractors(Etoposide, canonical = FALSE)

# 6. Etoposide + Nultin
Etoposide_Nutlin3 <- loadNetwork("1_Nutlin3.txt")
attr <- getAttractors(Etoposide_Nutlin3, canonical = FALSE)

# 7. Etoposide + Wip1
Etoposide_Wip1 <- loadNetwork("1_Wip1.txt")
attr <- getAttractors(Etoposide_Wip1, canonical = FALSE)

# 8. Etoposide + Nultin + Wip1

# Loading Network
Etoposide_Nutlin_Wip1 <- loadNetwork("1_Nutlin_Wip1.txt")

# Sketching Network
tic()
plotNetworkWiring(Etoposide_Nutlin_Wip1)
toc()

# Deterministic Analysis - Finding Attractors
tic()
attr <- getAttractors(Etoposide_Nutlin_Wip1, canonical = FALSE)
toc()

n = 16; # Number of nodes

# Probabilistic Analysis - numIterations = n
tic()
sim <- markovSimulation(Etoposide_Nutlin_Wip1, numIterations = n, returnTable = FALSE)
toc()


# Probabilistic Analysis - RECOMMENDED numIterations = 2^n
tic()
sim <- markovSimulation(Etoposide_Nutlin_Wip1, numIterations = 2^n, returnTable = FALSE)
toc()


