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

/**
 * WMSCLayer
 */
public class WMSCLayer extends TiledMapServiceLayer
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    private var _tileInfo:TileInfo ;  // see buildTileInfo() 
    private var _url:String = new String();
    private var _imgType:String = "png";
    private var _wmsLayer:String = new String(); 
    private var _srs:SpatialReference;
    private var _fullExtent:Extent;
    private var _initExtent:Extent;
    private var _units:String;
    
 	//目前只默认支持两种参考系，WGS84(4326),Web Mercator（102113），采用其他投影需要设置切图参数
 	//包括srsid，maxBBox，Origin，以及Resolution{res,scale} ,uints例如esriMeters
    public function WMSCLayer(wkid:Number = 4326,maxBBox:Extent=null,Origin:MapPoint=null,Resolution:Array=null,units:String=null,tileWidth:int=256,tileHeight:int=256):void
    {
    	//
        super();
        if(wkid == 4326)
        {
        	buildTileInfo4326(tileWidth,tileHeight);
        }
        else if(wkid == 102113||wkid == 102100)
        {
        	buildTileInfo102113(102100,tileWidth,tileHeight);
        }
        else
        {
        	buildTileInfoOther(wkid,maxBBox,Origin,Resolution,units,tileWidth,tileHeight);
        }
    // 
        // Map will only use loaded layers
      setLoaded(true);
    }
//    //只有在不使用默认两种坐标系的情况下才使用该函数  
//    public function InitTileInfo22():void
//	{
//		//
//		var i:int = 0;
//	//	buildTileInfo(srsid,maxBBox,Origin,Resolution,units,tileWidth,tileHeigth);
//
//	}

    //--------------------------------------------------------------------------
    //
    //  Overridden properties
    //      fullExtent()
    //      initialExtent()
    //      spatialReference()
    //      tileInfo()
    //      units()
    //
    //--------------------------------------------------------------------------

    
    //----------------------------------
    //  fullExtent
    //  - required to calculate the tiles to use
    //----------------------------------

    override public function get fullExtent():Extent
    {
    	return this._fullExtent;
 //       return new Extent(-180, -90, 180, 90, new SpatialReference(4326));
    }
    
    //----------------------------------
    //  initialExtent
    //  - needed if Map doesn't have an extent
    //----------------------------------

    override public function get initialExtent():Extent
    {
    	if(this._initExtent == null)
    	{
    		return this._fullExtent;
    	}
    	else
    	{
    		return this._initExtent;
    	}
    		
     //   return new Extent(-124.731422,24.955967,-66.969849, 49.371735,new SpatialReference(4326));
    }

    //----------------------------------
    //  spatialReference
    //  - needed if Map doesn't have a spatialReference
    //----------------------------------

    override public function get spatialReference():SpatialReference
    {
    	return this._srs;
       // return new SpatialReference(4326);
    }
    //----------------------------------
    //  tileInfo
    //----------------------------------


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
    	return _units;
       // return "esriDecimalDegrees";
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //      getTileURL(level:Number, row:Number, col:Number):URLRequest
    //
    //--------------------------------------------------------------------------

    override protected function getTileURL(level:Number, row:Number, col:Number):URLRequest
    {
    	// Use virtual cache directory
    	// This assumes the cache's virtual directory is exposed, which allows you access
    	// to tile from the Web server via the public cache directory.  
        // Example of a URL for a tile retrieved from the virtual cache directory:
    	// http://serverx.esri.com/arcgiscache/dgaerials/Layers/_alllayers/L01/R0000051f/C000004e4.jpg   
 //       var url:String = _baseURL
 //           + "/L" + padString(String(level), 2, "0")
 //           + "/R" + padString(row.toString(16), 8, "0")
 //           + "/C" + padString(col.toString(16), 8, "0") + ".png";
  var rurl:String =this._url + 
  		"LAYERS=" + this._wmsLayer+
  		"&FORMAT=image%2F" +this._imgType +
  		"&SERVICE=WMS" + 
  		"&VERSION=1.1.1" + 
  		"&REQUEST=GetMap" + 
  		"&STYLES=&EXCEPTIONS=application%2Fvnd.ogc.se_inimage"; 
  	//	"&SRS=EPSG%3A" + this._tileInfo.spatialReference.wkid+
  		if(this._tileInfo.spatialReference.wkid == 102113 ||this._tileInfo.spatialReference.wkid == 102100)
  		{
  			rurl = rurl+ "&SRS=EPSG%3A900913"; 			
  		}
  		else
  		{
  			rurl = rurl+"&SRS=EPSG%3A" + this._tileInfo.spatialReference.wkid;
  		}
  		rurl = rurl+
  		"&WIDTH="+this._tileInfo.width+
  		"&HEIGHT="+this.tileInfo.height+
  		"&BBOX=";
  		
  	//	x = this._tileInfo.origin.x+col*_tileInfo.width*_tileInfo.lods[level].resolution
  	//	y = this._tileInfo.origin.y-(row+1)*_tileInfo.height*_tileInfo.lods[level].resolution
  //		result.addItem(this.origin.add(new Coordinates(coordinates.x*this.tileWidth*this.resolution,coordinates.y*this.tileHeight*this.resolution)));
//			result.addItem(this.origin.add(new Coordinates((coordinates.x+1)*this.tileWidth*this.resolution,(coordinates.y+1)*this.tileHeight*this.resolution)));
		var LT:Point = new Point(this._tileInfo.origin.x+col*_tileInfo.width*_tileInfo.lods[level].resolution,this._tileInfo.origin.y-(row+1)*_tileInfo.height*_tileInfo.lods[level].resolution);	
		var RY:Point = new Point(this._tileInfo.origin.x+(col+1)*_tileInfo.width*_tileInfo.lods[level].resolution,this._tileInfo.origin.y-row*_tileInfo.height*_tileInfo.lods[level].resolution);
		var strBBox:String = LT.x.toString()+","+LT.y.toString()+","+RY.x.toString()+","+RY.y.toString();
		rurl		= rurl +strBBox;
		trace(rurl);
		var st:String = "\nl:"+level.toString()+"row:"+row.toString()+"col:"+col.toString()+"\n";
		trace(st);
        return new URLRequest(rurl);
    }
    
    //--------------------------------------------------------------------------
    //
    //  Private Methods
    //
    //--------------------------------------------------------------------------

    private function buildTileInfo4326(tileWidth:int,tileHeight:int):void
    {
    	 _tileInfo = new TileInfo();
        _tileInfo.height = tileHeight;
        _tileInfo.width = tileWidth;
        _tileInfo.origin = new MapPoint(-180, 90);
        _tileInfo.spatialReference = new SpatialReference(4326);
        this._srs = _tileInfo.spatialReference;
        this._units = "esriDecimalDegrees";
        this._fullExtent= new  Extent(-180, -90, 180, 90, new SpatialReference(4326));
        _tileInfo.lods = [
			new LOD(0, 0.351562499999999, 147748799.285417),
			new LOD(1, 0.17578125, 73874399.6427087),
			new LOD(2, 0.0878906250000001, 36937199.8213544),
			new LOD(3, 0.0439453125, 18468599.9106772),
			new LOD(4, 0.02197265625, 9234299.95533859),
			new LOD(5, 0.010986328125, 4617149.97766929),
			new LOD(6, 0.0054931640625, 2308574.98883465),
			new LOD(7, 0.00274658203124999, 1154287.49441732),
			new LOD(8, 0.001373291015625, 577143.747208662),
			new LOD(9, 0.0006866455078125, 288571.873604331),
			new LOD(10, 0.000343322753906249, 144285.936802165),
			new LOD(11, 0.000171661376953125, 72142.9684010827),
			new LOD(12, 0.0000858306884765626, 36071.4842005414),
			new LOD(13, 0.0000429153442382813, 18035.7421002707),
			new LOD(14, 0.0000214576721191406, 9017.87105013534),
			new LOD(15, 0.0000107288360595703, 4508.93552506767),
			new LOD(16, 0.0000053644180297851, 2254.467762533835),
			new LOD(17, 0.0000026822090148926, 1127.233881266918),
			new LOD(18, 0.0000013411045074463, 563.6169406334588),
			new LOD(19, 0.0000006705522537231, 281.8084703167294)
        ];
    }
	/*******************************************************************************
	 * http://wiki.osgeo.org/wiki/WMS_Tiling_Client_Recommendation
	 **Mercator Profile

    * Width: 256 px
    * Height: 256 px
    * Format: image/png
    * SRS: OSGEO:41001
    * BoundingBox: -20037508.34 -20037508.34 20037508.34 20037508.34
    * Resolutions: 156543.03390625 78271.516953125 ... 

	There is one tile at the highest resolution of the basic Mercator profile. 
	************************************************************************************/
	private function buildTileInfo102113(wkid:int,tileWidth:int,tileHeight:int):void
    {
    	 _tileInfo = new TileInfo();
        _tileInfo.height = tileHeight;
        _tileInfo.width = tileWidth;        
        this._fullExtent= new Extent(-22041257.773878, -32673939.6727517, 22041257.773878, 20851350.0432886, new SpatialReference(wkid));
   		_tileInfo.origin=new MapPoint(-20037508.342787, 20037508.342787);
  	 	_tileInfo.spatialReference=new SpatialReference(wkid);
  	 	this._srs = _tileInfo.spatialReference;
        this._units = "esriDecimalDegrees";
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
    private function buildTileInfoOther(srsid:Number,maxBBox:Extent,Origin:MapPoint,Resolution:Array,units:String,tileWidth:int,tileHeigth:int):void
    {
        _tileInfo = new TileInfo();
    	 _tileInfo.height = tileHeigth;
        _tileInfo.width = tileWidth;        
        this._fullExtent= maxBBox;
   		_tileInfo.origin=Origin;
  	 	_tileInfo.spatialReference=new SpatialReference(srsid);
  	 	this._srs = _tileInfo.spatialReference;
        this._units = units;
        var i:int = 0;
        if(Resolution != null)
        {
        	_tileInfo.lods = new Array();
        	for(i=0;i<Resolution.length;i++)
        	{
        		_tileInfo.lods.push(new LOD(i, Resolution[i],1000/(2*i)));
        	}
        } 		
    }
    private function padString(text:String, size:int, ch:String):String
    {
        while (text.length < size)
        {
            text = ch + text;
        }
        return text;
    }
    public function set url(val:String):void
    {
    	this._url = val;
    }
    public function set wmsLayer(val:String):void
    {
    	this._wmsLayer = val;
    }
     public function set imgType(val:String):void
    {
    	this._imgType = val;
    }
    public function set initExtent(val:Extent):void
    {
    	this._initExtent = val;
    }

}
}
