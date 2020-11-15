final String tableLocations = 'TableTrackInfo';
final String columnID = '_id';
final String columnAvgSpeed = 'avgSpeed';
final String columnDistance = 'distance';
final String columnInitialLat = 'initialPosLat';
final String columnInitialLng = 'initialPosLng';
final String columnFinalLat = 'finalPosLat';
final String columnFinalLng = 'finalPosLng';

class TrackInfo {

  int id;
  double avgSpeed;
  double distance;
  double initPosLat;
  double initPosLng;
  double fPosLat;
  double fPosLng;
  


  TrackInfo({this.id, this.avgSpeed, this.distance, this.initPosLat, this.initPosLng, this.fPosLat, this.fPosLng});

  TrackInfo.fromMap(Map<String, dynamic> map){
    id = map[columnID];
    avgSpeed = map[columnAvgSpeed];
    distance = map[columnDistance];
    initPosLat = map[columnInitialLat];
    initPosLat = map[columnInitialLng];
    fPosLat = map[columnFinalLat];
    fPosLng = map[columnFinalLng];
  }

  Map<String, dynamic> toMap(){
    var map = <String, dynamic>{
          columnID: id,
          columnAvgSpeed: avgSpeed,
          columnDistance: distance,
          columnInitialLat: initPosLat,
          columnInitialLng: initPosLng,
          columnFinalLat: fPosLat,
          columnFinalLng: fPosLng
        };
        if (id != null) {
          map[columnID] = id;
        }
        return map;
  }

}


