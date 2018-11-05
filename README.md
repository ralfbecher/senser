# R Package to retrieve data from Qlik Sense

This Package provides functions to connect Qlik Sense via [q-risotto](https://github.com/ralfbecher/q-risotto) (the Qlik Sense REST API wrapper service) and to retrieve data out of Qlik Sense applications by defining HyperCubes.

## Installation

Install the package senser from GitHub in your R environment:

```
install.packages("devtools")
library(devtools)
install_github("ralfbecher/senser")
```

## Functions

* **senser_data**: Retrieves a dataframe containing data from a Qlik Sense HyperCube
* **senser_timeline**: Retrieves a dataframe containing timeline data with a date vector from a Qlik Sense HyperCube
* **senser_timeline_fmt**: Retrieves a dataframe containing timeline data with a formatted date vector from a Qlik Sense HyperCube

See more details in package docu and [q-risotto README](https://github.com/ralfbecher/q-risotto/blob/master/README.md).

***

### Author

**Ralf Becher**

* [irregular.bi](http://irregular.bi)
* [twitter/irregularbi](http://twitter.com/irregularbi)
* [github.com/ralfbecher](http://github.com/ralfbecher)

[irregular.bi]: http://irregular.bi
[twitter/irregularbi]: http://twitter.com/irregularbi
[github.com/ralfbecher]: http://github.com/ralfbecher

### License

Copyright © 2018 Ralf Becher

Released under the MIT license.

***