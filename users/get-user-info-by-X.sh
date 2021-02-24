# Get sorted list of User Roles - Search by email
gc users list --expand="authorization" | jq -cr 'first(.[] | select(.email == "user.email@example.com")) | .authorization.roles[].name' | sort --ignore-case

########
# Composition:
# Search users first, then expand to get details
# Reduces data transmission at the expense of more API calls
########

# Search for a user by email, then expand to get user data (xargs - supports multiple)
gc users list | jq -rc '.[] | select(.email == "user.email@example.com") | .id' | xargs -I % gc users get % --expand authorization

# Search for a user by email, then expand to get user data (Command substitution)
gc users get `gc users list  --expand authorization | jq -rc 'first(.[] | select(.email == "user.email@example.com")) | .id'`
