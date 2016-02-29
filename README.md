# Yeoman Generator for Mule ESB Projects

A simple template based generator for Mule, written using Coffee Script

  To generate an empty mule project (with subfolders)

``` shell
Usage:

  yo mule:app [options] [<name>] [<description>]

Options:
  -h,     --help          # Print the generator's options and usage
          --skip-cache    # Do not remember prompt answers             Default: false
          --skip-install  # Do not automatically install dependencies  Default: false

  -mvn,   --maven         # Generate / Convert project to maven. ## ** Unsupported at this time

Arguments:
  name           Type: String  Required: false
  description    Type: String  Required: false

  To generate a mavenized pom configuration (supports both Community and Enterprise Edition projects)

``` shell

  yo mule:maven [options]

Options:
  -h,    --help          # Print the generator's options and usage
         --skip-cache    # Do not remember prompt answers                  Default: false
         --skip-install  # Do not automatically install dependencies       Default: false
  -ce,   --community     # Creates a Mule Community Edition (CE) project   Default: false
  -ee,   --enterprise    # Creates a Mule Enterprise Edition (EE) project  Default: false
```

## Examples

  yo mule "sample project" "sample description"
  yo mule:maven --ce

  To switch to EE config 

  yo mule:maven --ee


# Roadmap 

* Maven     - unmavenize - Remove the mavenization from the project
* Gitlab    - A generator that wraps gitlab integration
              Will support create and mr as two actions
* Dockerize - A generator that will embed a spotify/docker-maven-plugin integration
