# NotebookToSite

## Installation

You can install this package using the devtools function install_github.  

```{r}
install.packages("devtools")
devtools::install_github("kdgosik/NotebookToSite")
```

## Usage

Once you have the package installed you can use the functions in a typical R session.  The main function to use is <code> create_site() </code> function.  This will create folders for docs, results and references.  Inside the docs folder it will have an index.html and a FinaNotebook.html among other files.  These can be used as a github pages site for your project.  You would have to enable this functionality for your github repository to render files in the docs folder into a site.  Under your repository go to the Settings tab, scroll down to the Github Pages section and under the source option change the drop down menu from 'None' to master branch/docs folder.  Just like that you have a basis for a website to share your project analysis!

```{r}
library(NotebookToSite)

# enter your github user name into the paramter for the function
create_site(github_username = "kdgosik")
```

After you run this function all files and directories are created in the present working directory you are currently in.  A Notebook.Rmd file will be placed inside the src directory.  You can edit and use this file for your analysis.  Once you are happy and would like to update the analysis to the site you run the <code>update_site()</code> function.  This will knit new html files to reflect the updates you made to your code. 

```{r}
library(NotebookToSite)
# Must be in the same project directory used when running create_site()
update_site()
```


## Future Work

This is the first iteration of this package.  Pull requests and suggestions are welcome. I will update this with new ideas as they come to me. Let me know if you have anything you would like added to this to make it more robust.
