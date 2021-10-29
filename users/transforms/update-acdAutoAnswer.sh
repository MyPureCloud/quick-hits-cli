# >> START update-acdAutoAnswer Use the experimental transform feature in the CLI along with a Go template to filter and then do a bulk update of the autoAcdAnswer 

########
#  This template file will be used to identify all users who have "Agent" in their title and whose acdAutoAnswer function is set to false.  It will then build a JSON body that
#  turns the acdAutoAnswer feature to true.
#######


# Example transforms template.  Place this content into a file called acdautoansweron_bulk.tmpl
{{ $l:=len . | sub 1 | mul -1}}
[{{- range $i, $el := . -}}
{{if and (eq "Agent" .title) (eq false .acdAutoAnswer)}}{
"id": "{{$el.id}}",
"acdAutoAnswer": true
}{{if lt $i $l}},{{end}}
{{- end -}}{{end}}]

# To see the transformed output
gc users list -a --transform acdautoansweron_bulk.tmpl

# To transform the output and then redirect it to the bulk update.  Remember the gc users bulk update API can only update a total of 50 records.
gc users list -a --transform acdautoansweron_bulk.tmpl | gc users bulk update

# >> END convert-users-to-csv-with-transform
