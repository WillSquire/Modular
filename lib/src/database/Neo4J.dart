part of databases;

class Neo4J extends Database
{
  //-------------------------------------------------------------------------------------------
  // Variables - Public
  //-------------------------------------------------------------------------------------------
  
  String host; // = 'localhost';
  int port; // = 7474;
  
  //-------------------------------------------------------------------------------------------
  // Variables - Private
  //-------------------------------------------------------------------------------------------
  
  Client connection;
  
  //-------------------------------------------------------------------------------------------
  // Functions
  //-------------------------------------------------------------------------------------------
  
  Neo4J (this.host, this.port)
  {
    connection = new Client();
  }
  
  //-------------------------------------------------------------------------------------------
  // Functions - CRUD
  //-------------------------------------------------------------------------------------------
  
  /**
   * Connects to Neo4J's REST-ful API
   */
  
  Future<Object> create(var newDatabaseObject)
  {
    print(JSON.encode(newDatabaseObject));
    return connection.post(URL() + "node", body: JSON.encode(newDatabaseObject))
    .then((response) => JSON.decode(response.body));
  }
  
  //-------------------------------------------------------------------------------------------
  
  Future<Object> read(int id)
  {
    return connection.get(URL() + "node/" + id.toString())
    .then((response) => JSON.decode(response.body));
  }
  
  //-------------------------------------------------------------------------------------------
  
  Future<Object> update(int id, var newPropertiesObject)
  {
    return connection.put(URL() + "node/" + id.toString() + "/properties", body: JSON.encode(newPropertiesObject))
    .then((response) {
      if (response.body.isEmpty) return true; // Nothing returned means successful
      return JSON.decode(response.body);
    });
  }
  
  //-------------------------------------------------------------------------------------------
  
  Future<Object> delete(int id)
  {
    return connection.delete(URL() + "node/" + id.toString())
    .then((response) {
      if (response.body.isEmpty) return true; // Nothing returned means successful
      return JSON.decode(response.body);
    });
  }
  
  //-------------------------------------------------------------------------------------------
  // Functions
  //-------------------------------------------------------------------------------------------
  
  String URL ()
  {
    return "http://" + host + ":" + port.toString() + "/db/data/";
  }
  
  //-------------------------------------------------------------------------------------------
  
  void close()
  {
    connection.close();
    connection = null;
  }
}