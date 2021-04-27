///////////////////////////////////////////////////////////////////////////////////////////////////////
//  DESCRIPTION
//      Filters all users with skills in the removeSkills array and removes those skills to that user.
//      After removing the skills, use the blukremove to add skills to the same user in bulk.
//  PRE-REQUISITE
//      If you are using Windows, rename your jq-win64.exe or jq-win32.exe to jq.exe
//  NODE VERSION
//      Node v14.16.1
///////////////////////////////////////////////////////////////////////////////////////////////////////

const execSync = require('child_process').execSync;

let removeSkills = ['Juggling','Fire Breathing','Origami'];

console.log('Working on it...');

// Loop through each skill to be deleted
removeSkills.forEach(skill => {
    let jqBuilder = 'jq -c -r \'[.[] | select(.skills[].name=="'+ skill +'")]\''

    // Rename your jq-win64.exe or jq-win32.exe to jq.exe
    if(process.platform === 'win32') jqBuilder = 'jq -c -r "[.[] | select(.skills[].name==""'+ skill +'""")]"';

    userData = execSync('gc users list -a --pageSize=100 --expand="skills" | '+ jqBuilder +'');

    var obj = JSON.parse(userData);

    if(obj.length > 0) {
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
    } else console.log('No user found for skill ' + skill);
});