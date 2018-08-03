

function init() {
    document.addEventListener('deviceready', function(event){
        createDB();
    })
    document.getElementById("btn1").addEventListener('click', insertData);
    document.getElementById("btn2").addEventListener('click', readData);
    document.getElementById("btn3").addEventListener('click', updateData);
    document.getElementById("btn4").addEventListener('click', deleteData);
    document.getElementById("btn5").addEventListener('click', createDB);
}

init();

function insertData() {
    var insertQuery = "INSERT INTO studentsDetail (regno, name, department, year) VALUES (49, 'Tina', 'Computer', '2018')";
    SqliteConnect.insertData(insertQuery, function(pluginResponse){
        console.log('pluginResponse ' + pluginResponse);
        if(pluginResponse === 'success'){
            alert('insertion successful');
        }else{
            alert('failure');
        }
        
    });
}

function readData() {
    var selectQuery = "SELECT * FROM studentsDetail";
    SqliteConnect.readData(selectQuery, function(pluginResponse){
        console.log('pluginresponse ' + pluginResponse);
        alert(pluginResponse);
    });
}

function updateData() {
    var updateQuery = "";
    SqliteConnect.update(selectQuery, callback);
}

function deleteData() {

}

function createDB(){
    SqliteConnect.createDB(callback);
}

var callback = function (pluginResponse) {
    console.log('hello');
    console.log('pluginResponse ' + pluginResponse);
}