final String tableLocations = 'TableTrackInfo';
final String columnID = '_id';
final String columnAvgSpeed = 'avgSpeed';
final String columnDistance = 'distance';
final String columnInitial = 'initialPos';
final String columnFinal = 'finalPos';

class TrackInfo {

  int id;
  double avgSpeed;
  double distance;
  double initPos;
  double fPos;


  TrackInfo({this.id, this.avgSpeed, this.distance, this.initPos, this.fPos});

  TrackInfo.fromMap(Map<String, dynamic> map){
    id = map[columnID];
    avgSpeed = map[columnAvgSpeed];
    distance = map[columnDistance];
    initPos = map[columnInitial];
    fPos = map[columnFinal];
  }

  Map<String, dynamic> toMap(){
    var map = <String, dynamic>{
          columnID: id,
          columnAvgSpeed: avgSpeed,
          columnDistance: distance,
          columnInitial: initPos,
          columnFinal: fPos
        };
        if (id != null) {
          map[columnID] = id;
        }
        return map;
  }

}


