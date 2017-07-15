# Fit n number of Lorentzian peaks to data

1. Download fitnlorentzian.m plus example data in 4peaksdata.dat (or clone repo) 
2. in matlab run
```matlab
    % import xy data
    data = load('4peaksdata.dat');
    
    % fit data with n = 1,...,4 peaks
    n = 4;
    fitnlorentzian(data, n)
```

# Fit n number of Gaussian peaks to data

[coming soon]



