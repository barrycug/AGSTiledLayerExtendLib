package net.giser.www
{
	public class TianDiTuMapslayer extends TiledMapServiceLayer
        {
                public function TianDiTuMapslayer()
                {
                        super();
                        buildTileInfo();
                        setLoaded(true);
                }
               
                private var _tileInfo:TileInfo=new TileInfo();
                private var _baseURL:String="";
               
               
                override public function get fullExtent():Extent
                {
                        return new Extent(-180, -90, 180, 90, new SpatialReference(4326));
                }
               
                override public function get initialExtent():Extent
                {
                        return new Extent(-180, -90, 180, 90, new SpatialReference(4326));
                }
               
                override public function get spatialReference():SpatialReference
                {
                        return new SpatialReference(4326);
                }
               
                override public function get tileInfo():TileInfo
                {
                        return _tileInfo;
                }
               
                //获取矢量地图
                override protected function getTileURL(level:Number, row:Number, col:Number):URLRequest
                {
                        var url:String="http://tile2.tianditu.com/DataServer?T=A0512_EMap&" +
                                "X=" + col + "&" +
                                "Y=" + row + "&" +
                                "L=" + level;
                       
                        return new URLRequest(url);
                }
               
                private function buildTileInfo():void
                {
                        _tileInfo.height=256;
                        _tileInfo.width=256;
                        _tileInfo.origin=new MapPoint(-90 ,45 ,new SpatialReference(4326));
                        _tileInfo.spatialReference=new SpatialReference(4326);
                        _tileInfo.lods = [
                                new LOD(1, 0.3515625, 147748799.285417),
                                new LOD(2, 0.17578125, 73874399.6427087),
                                new LOD(3, 0.087890625, 36937199.8213544),
                                new LOD(4, 0.0439453125, 18468599.9106772),
                                new LOD(5, 0.02197265625, 9234299.95533859),
                                new LOD(6, 0.010986328125, 4617149.97766929),
                                new LOD(7, 0.0054931640625, 2308574.98883465),
                                new LOD(8, 0.00274658203125, 1154287.49441732),
                                new LOD(9, 0.001373291015625, 577143.747208662),
                                new LOD(10, 0.0006866455078125, 288571.873604331),
                                new LOD(11, 0.00034332275390625, 144285.936802165),
                                new LOD(12, 0.000171661376953125, 72142.9684010827),
                                new LOD(13, 8.58306884765629E-05, 36071.4842005414),
                                new LOD(14, 4.29153442382814E-05, 18035.7421002707),
                                new LOD(15, 2.14576721191407E-05, 9017.87105013534),
                                new LOD(16, 1.07288360595703E-05, 4508.93552506767),
                                new LOD(17, 5.36441802978515E-06, 2254.467762533835),
                                new LOD(18, 2.68220901489258E-06, 1127.2338812669175)
                        ];
                }
        }
}