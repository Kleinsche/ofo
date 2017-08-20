//
//  ViewController.swift
//  ofoRide
//
//  Created by 🍋 on 2017/6/11.
//  Copyright © 2017年 🍋. All rights reserved.
//

import UIKit
import SWRevealViewController
class ViewController: UIViewController,MAMapViewDelegate,AMapSearchDelegate {
    @IBOutlet weak var panelView: UIView!
    var mapView: MAMapView!
    var search: AMapSearchAPI!
    var pin: myPinAnnotation!
    


    //点击定位
    @IBAction func locationBtnTap(_ sender: UIButton) {
        searchBikeNearby()
    }
    
    //搜索周边小黄车
    func searchBikeNearby() {
        searchCustomLocation(mapView.userLocation.coordinate)
    }
    
    //周边搜索
    func searchCustomLocation(_ center: CLLocationCoordinate2D) {
        let request = AMapPOIAroundSearchRequest()
        request.location = AMapGeoPoint.location(withLatitude: CGFloat(center.latitude), longitude: CGFloat(center.longitude))
        request.keywords = "停车场"
        //        request.radius = 500
        //        request.sortrule = 30
        request.requireExtension = true
        //发起周边检索
        search.aMapPOIAroundSearch(request)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        AMapServices.shared().enableHTTPS = true
        
        //载入地图
        mapView = MAMapView(frame: self.view.bounds)
        mapView.delegate = self
        view.addSubview(mapView)
        
        mapView.zoomLevel = 15 //缩放
        
        search = AMapSearchAPI()
        search.delegate = self
        
        view.bringSubview(toFront: panelView)
        
        //侧边栏
        if let revealVC = revealViewController() {
            revealVC.rearViewRevealWidth = 280
            navigationItem.leftBarButtonItem?.target = revealVC
            navigationItem.leftBarButtonItem?.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(revealVC.panGestureRecognizer())
        }
        
        self.navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "ofoLogo"))
        self.navigationItem.leftBarButtonItem?.image = #imageLiteral(resourceName: "leftTopImage").withRenderingMode(.alwaysOriginal)
        self.navigationItem.rightBarButtonItem?.image = #imageLiteral(resourceName: "rightTopImage").withRenderingMode(.alwaysOriginal)
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Map View Delegate
    
    /// 地图加载完成
    ///
    /// - Parameter mapView: mapView
    func mapInitComplete(_ mapView: MAMapView!) {
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .followWithHeading
        
        pin = myPinAnnotation()
        pin.coordinate = mapView.centerCoordinate
        pin.lockedScreenPoint = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
        pin.isLockedToScreen = true
        
        mapView.addAnnotation(pin)
//        mapView.showAnnotations([pin], animated: true)
        
    }
    
    /// 自定义大头针
    ///
    /// - Parameters:
    ///   - mapView: mapView
    ///   - annotation: 标注
    /// - Returns: 大头针视图
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        if annotation is MAUserLocation {
            return nil
        }
        
        //固定中心大头针
        if annotation is myPinAnnotation {
            let reuseID = "centerPin"
            var centerPin = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID) as? MAPinAnnotationView
            
            if centerPin == nil {
                centerPin = MAPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            }
            
            centerPin?.image = #imageLiteral(resourceName: "homePage_wholeAnchor")
            centerPin?.canShowCallout = false
            centerPin?.animatesDrop = false
            
            return centerPin
        }
        
        let pointReuseIndetifier = "pointReuseIndetifier"
        var annotationView:MAPinAnnotationView! = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier) as? MAPinAnnotationView
        //重复利用节约内存
        if annotationView == nil {
            annotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
        }
        
        
        
        if annotation.title == "正常可用" {
            annotationView?.image = #imageLiteral(resourceName: "HomePage_nearbyBike")
        }else{
            annotationView?.image = #imageLiteral(resourceName: "HomePage_nearbyBikeRedPacket")
        }
        
        annotationView?.canShowCallout = true
        annotationView!.animatesDrop = true
        
        return annotationView
    }
    
    
    // MARK: - Map Search Delegate

    //回调处理数据
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        
        guard response.count > 0 else {
            print("附近没有停车场")
            return
        }
        
        //解析response获取POI信息
        //        for poi in response.pois {
        //            print(poi.name,poi.location)
        //
        ////            dump(poi)
        //        }
        
        var annotations: [MAPointAnnotation] = []
        /*
         annotations = response.pois.map{loc in
         
         let annotation = MAPointAnnotation()
         annotation.coordinate = CLLocationCoordinate2D.init(latitude: CLLocationDegrees(loc.location.latitude), longitude: CLLocationDegrees(loc.location.longitude))
         
         if loc.distance <= 200 {
         annotation.title = "红包区域内开启任意小黄车"
         annotation.subtitle = "骑行10分钟可获得现金红包"
         }else{
         annotation.title = "正常使用"
         }
         
         return annotation
         }
         */
        
        
        for poi in response.pois {
            let annotation = MAPointAnnotation()
            if let location = poi.location {
                annotation.coordinate = CLLocationCoordinate2D.init(latitude: CLLocationDegrees(location.latitude), longitude: CLLocationDegrees(location.longitude))
                
                if poi.distance <= 500 {
                    annotation.title = "红包车"
//                    annotation.subtitle = "骑行10分钟可获得现金红包"
                }else{
                    annotation.title = "正常可用"
                }
                
                annotations.append(annotation)
            }
        }
        
        mapView.addAnnotations(annotations)
        mapView.showAnnotations(annotations, animated: true)
        
    }
    

}

