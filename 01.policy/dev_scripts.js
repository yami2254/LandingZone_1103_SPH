const BEARER = ""; // token 값 입력
const MANAGEMENT_GROUP_ID = ""; // management group ID 입력

for(var i=1; i<40; i++) {
  fetch('https://management.azure.com/providers/Microsoft.Management/managementGroups/' + MANAGEMENT_GROUP_ID + '/providers/Microsoft.Authorization/policyAssignments/assignment_'+i+'?api-version=2019-09-01', {
    method: 'DELETE',
    headers: {
      "Authorization": "Bearer " + BEARER,
      'Content-Type': 'application/json'
    }
  })
  .then(res => res.json())
  .then(response => console.log('Success:', JSON.stringify(response)))
  .catch(error => console.error('Error:', error));
}

