package net.giser.www
{
	import com.esri.ags.SpatialReference;
	import com.esri.ags.geometry.Extent;
	import com.esri.ags.geometry.MapPoint;
	import com.esri.ags.layers.LOD;
	import com.esri.ags.layers.TileInfo;
	import com.esri.ags.layers.TiledMapServiceLayer;
	import flash.geom.Point;
	import flash.net.URLRequest;

	public class OpenStreetMapLayer extends TiledMapServiceLayer
	{
		public function OpenStreetMapLayer()
		{
			super();       
	        buildTileInfo(); // to create our hardcoded tileInfo        
	        setLoaded(true); // Map will only use loaded layers

		}
	private var _tileInfo:TileInfo = new TileInfo();  // see buildTileInfo() 
	private var _subDomains:Array = ["a","b","c"];
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
  	var subdomain:String = _subDomains[(level + col + row) % _subDomains.length];
     var _baseURL:String="http://"+subdomain+".tile.openstreetmap.org/";     
     var url:String=_baseURL + level.toString()+"/"+col.toString() + "/" + row.toString()+ ".png";
     return new URLRequest(url);
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
}