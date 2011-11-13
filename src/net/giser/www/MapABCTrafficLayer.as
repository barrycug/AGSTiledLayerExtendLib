package net.giser.www
{
	import com.esri.ags.SpatialReference;
	import com.esri.ags.geometry.Extent;
	import com.esri.ags.geometry.MapPoint;
	import com.esri.ags.layers.LOD;
	import com.esri.ags.layers.TileInfo;
	import com.esri.ags.layers.TiledMapServiceLayer;
	
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.utils.Timer;

	public class MapABCTrafficLayer extends TiledMapServiceLayer
	{
		private var myTimer:Timer = new Timer(120000, 0);
		private var _date:Date ;
		private var _timeStamp:String;
		public function MapABCTrafficLayer()
		{
			super();       
	        buildTileInfo(); // to create our hardcoded tileInfo
	         
            myTimer.addEventListener("timer", timerHandler);
            myTimer.start();
            _date= new Date();
            _timeStamp = GetTimeStamp(_date);
	        setLoaded(true); // Map will only use loaded layers

		}
		 public function timerHandler(event:TimerEvent):void 
		 {
		// 	
            trace("timerHandler: " + event);
            _date= new Date();
            _timeStamp = GetTimeStamp(_date);
            this.invalidateLayer();
            this.refresh();
            this.invalidateDisplayList();
        }
	private function GetTimeStamp(date:Date):String
	{
		var timeStamp:String;
		timeStamp = date.getMonth().toString()+date.getHours().toString()
					+date.getMinutes().toString()+date.getMinutes().toString();
					
		return timeStamp;
	}
	private var _tileInfo:TileInfo = new TileInfo();  // see buildTileInfo() 
    override public function get tileInfo():TileInfo
    {
        return _tileInfo;
    }

    //----------------------------------
    //  units
    //  - needed if Map doesn't have it set
    //----------------------------------

    override public function get units():String
    {
        return "esriMeters";
    }

  override public function get fullExtent():Extent
  {
   return new Extent(-22041257.773878, -32673939.6727517, 22041257.773878, 20851350.0432886, new SpatialReference(102113));
  }
  override public function get initialExtent():Extent
     {
            return new Extent(-22041257.773878, -32673939.6727517, 22041257.773878, 20851350.0432886, new SpatialReference(102113));
      }

  override public function get spatialReference():SpatialReference
  {
   return new SpatialReference(102113);
  }
  //http://mt2.google.cn/vt/v=w2.116&hl=en&gl=cn&x=1688&y=775&z=11&s=Galileo
  override protected function getTileURL(level:Number, row:Number, col:Number):URLRequest
  {
  //	http://emap3.mapabc.com/mapabc/maptile?v=w2.61&x=1686&y=777&z=11
//	http://tm.mapabc.com/trafficengine/mapabc/traffictile?x=3369&y=1554&zoom=5&t=1785753
	if(level >6)
	{
     var _baseURL:String="http://tm.mapabc.com/trafficengine/mapabc/traffictile?&x=";     
     var url:String=_baseURL  +col.toString() + "&y=" + row.toString() + 
     "&zoom="+(17-level).toString()+"&t="+_timeStamp;
     return new URLRequest(url);
 	}
 	else 
 	return new  URLRequest("");
  }

  private function buildTileInfo():void
  {
   _tileInfo.height=256;
   _tileInfo.width=256;
   _tileInfo.origin=new MapPoint(-20037508.342787, 20037508.342787);
   _tileInfo.spatialReference=new SpatialReference(102113);
   _tileInfo.lods = [  
    new LOD(0, 156543.03392800014, 591657527.591555),
     new LOD(1, 78271.516963999937, 295828763.79577702),
     new LOD(2, 39135.758482000092, 147914381.89788899),
     new LOD(3, 19567.879240999919, 73957190.948944002),
     new LOD(4, 9783.9396204999593, 36978595.474472001),
     new LOD(5, 4891.9698102499797, 18489297.737236001),
     new LOD(6, 2445.9849051249898, 9244648.8686180003),
     new LOD(7, 1222.9924525624949, 4622324.4343090001),
     new LOD(8, 611.49622628138, 2311162.217155),
     new LOD(9, 305.748113140558, 1155581.108577),
     new LOD(10, 152.874056570411, 577790.554289),
     new LOD(11, 76.4370282850732, 288895.277144),
     new LOD(12, 38.2185141425366, 144447.638572),
     new LOD(13, 19.1092570712683, 72223.819286),
     new LOD(14, 9.55462853563415, 36111.909643),
     new LOD(15,4.7773142679493699, 18055.954822),
     new LOD(16, 2.3886571339746849, 9027.9774109999998),
     new LOD(17, 1.1943285668550503, 4513.9887049999998),
     new LOD(18, 0.59716428355981721, 2256.994353),
     new LOD(19, 0.29858214164761665, 1128.4971760000001)

          ];  
 
     }
	}
}// ActionScript file
