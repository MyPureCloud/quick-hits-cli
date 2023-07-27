## >> START archy_to_different_output A simple shell script that demonstrates how direct two flows of different types, but the same name to two different output folders

#
#  This was Unix/OSX/Linux/Shell script submitted by Craig Henderson (craig.henderson@muirfieldbusiness.com) example that takes the output from a the Genesys Cloud blog post ((https://developer.genesys.cloud/blog/2021-11-06-exporting-archy-flows-in-bulk/#writing-the-transform) and makes sure that if
#  two flows of different types have the same name they will be written to separate output directories that are appeneded with the flow type.  
#
#   This solutions involves three pieces:
#
#  1. The Genesys Cloud CLI to get the list of all of the flows in your Genesys Cloud instance:  gc flows list -a --transform
#
#  2. A Genesys Cloud CLI transform that will generate an Archy command for exporting the file.  This transform is contained in the archy_export_all.go file
#     and looks like this: 
#
#     {{- range . -}}{{printf "archy export --flowName \"%s\" --flowType %s --exportType yaml --outputDir output --force\n" .name (lower .type)}}{{end}}
#
#  3. The shell script below that will transform the produced output to make sure that the flows are written to a directory specific to their flow type.
#
#  To use the command you need to save this file and make sure it has executable permission (e.g chmod 755 exportarchy.sh) and then run the command below:
#
#  gc flows list -a --transform archy_export_all.go | ./archy_to_different_output.sh
#
#  Overall this is a pretty example of how you can take the CLI and use common OS shell and scripting tools to accomplish administrative tasks.
#
#
 

# The transform command is in the “archy_export_all.go” file. The output of the gc transform is piped into the archy_to_different_output.sh script which then creates export commands that write the yaml files into a directory for each type of flow.
output=$(awk -F' ' '
  {
    for (i=1; i<=NF; i++) {
      if ($i == "--flowType") {
        flowType=$(i+1)
      }
      if (flowType && $i == "output") {
        $i="export_"flowType
      }
    }
    print
  }
')

echo "$output"

## >> END archy_to_different_output