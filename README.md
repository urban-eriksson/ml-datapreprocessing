# ml-datapreprocessing
Selected tools for preparing data for machine learning

## Removing disparate impact ##

Disparate impact is when one group of people is affected in a negative way (discriminated against) compared to another group, even if the rules are neutral, i.e. not using some protected attribute in the decision process. The protected attribute can for instance be race, sex, or age to take a few examples. 

Removing disparate impact can be done by changing feature values in a certain way so that the distribution becomes insensitive to the protected attribute. Remember that the same transform has to be applied to every data point in production and that the transform will be dependent on the sensitive attribute. 

<p align="center"> 
<img src="https://github.com/urban-eriksson/ml-datapreprocessing/blob/master/images/removing_disparate_impact.png">
</p>

<p align="center"> 
<img src="https://github.com/urban-eriksson/ml-datapreprocessing/blob/master/images/removing_disparate_impact2.png">
</p>
