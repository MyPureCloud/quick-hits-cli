const execSync = require('child_process').execSync;

let removeSkills = ['Juggling','Fire Breathing','Origami'];

if(process.platform === 'linux'){
    console.log('Working on it...');
    // Loop through each skill to be deleted
    removeSkills.forEach(skill => {
        userData = execSync('gc users list -a --pageSize=100 --expand="skills" | jq -c -r \'[.[] | select(.skills[].name=="'+ skill +'")]\'');

        var obj = JSON.parse(userData);

        // Loop through each user with skill
        obj.forEach(user => {
            skillArr = user.skills.find(x => x.name == skill);

            // Remove skill for each user
            execSync('gc users skills delete '+ user.id +' '+ skillArr.id +'');
            console.log('EXECUTING SCRIPT: gc users skills delete '+ user.id +' '+ skillArr.id +'');
            console.log('Removed Skill ' + skill + ' for user ' + user.name+'');

            // Bulk add skills for each user
            execSync('gc users skills bulkremove '+ user.id +' -f ./bulk-add-skills.json');
            console.log('EXECUTING SCRIPT: gc users skills bulkremove '+ user.id +' -f ./bulk-add-skills.json');
            console.log('Added Skills for user ' + user.name+'');

            // bulk-add-skills.json file contents
            // [
            //     {
            //         "id": "0d180abb-51ef-4e26-b03e-07cd51488f06",-> Skill Id
            //         "proficiency": 5.0                           -> Valid values are from 0.0 to 5.0
            //     },
            //     {
            //         "id": "7bc2689d-a25d-4bd5-b8a6-a4cec09fabba",
            //         "proficiency": 5.0
            //     }
            // ]
        });
    });
} else console.log('This script only runs on Linux');