# matlab code examples 
Erik Bauch, May 2017

### fitnlorentzian.m - Fit n number of Lorentzian peaks to data

1. Download fitnlorentzian.m plus example data in 4peaksdata.dat (or clone repo) 
2. in matlab run
```matlab
    % import xy data
    data = load('4peaksdata.dat');
    
    % fit data with n = 1,...,4 peaks
    n = 4;
    fitnlorentzian(data, n)
```

![Lorentzian fitting example](https://github.com/ebauch/matlab/blob/master/4peaksdata.png)

this code on [mathworks fileexchange](https://www.mathworks.com/matlabcentral/fileexchange/63748-fitnlorentzian-xydata--parameters--fit-sum-of-lorentzian-to-data)

# Fit n number of Gaussian peaks to data

[coming soon]



