//
//  CoordinateViewController.swift
//  Waasdu
//
//  Created by Алексей on 15.05.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import MapKit

protocol CoordinateDisplayLogic: AnyObject {
    
    func displayCircle(viewModel: Coordinate.ViewModel.Element.Circle)
    func displayLines(viewModel: Coordinate.ViewModel.Element.Lines)
    func updateLabel(viewModel: Coordinate.ViewModel.Element.Distance)
    
}

class CoordinateViewController: UIViewController, CoordinateDisplayLogic {
    var interactor: CoordinateBusinessLogic?
    var color: UIColor = .red
    let mapView: MKMapView = MKMapView()
    var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.text = ""
        return label
    }()


    // MARK: Object lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: Setup

    private func setup() {
        let viewController = self
        let interactor = CoordinateInteractor()
        let presenter = CoordinatePresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
        
    }

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        addConstraint()
        mapView.delegate = self
        getPolyline()
        let gRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGesture(sender:)))
        mapView.addGestureRecognizer(gRecognizer)
    }

    // Отслеживаем нажатие на карту
    @objc func tapGesture(sender: UITapGestureRecognizer) {
        if sender.state == .ended{
            let locationInView = sender.location(in: mapView)
            let coordinats = mapView.convert(locationInView, toCoordinateFrom: mapView)
            drawCircle(coordinats: coordinats)
        }
    }
    // Рисуем линию вокруг региона
    func drawCircle(coordinats: CLLocationCoordinate2D) {
        let request = Coordinate.Request.RequestType.GetCircle(coordinats: coordinats)
        interactor?.getRegion(request: request)
    }
    // Инициализируем запрос координат границы
    func getPolyline() {
        interactor?.getCoordinatsLine()
    }
    // Размечаем круг по координатам
    func displayCircle(viewModel: Coordinate.ViewModel.Element.Circle) {
        mapView.addOverlay(viewModel.params)
    }
    // Размечаем линии по координатам
    func displayLines(viewModel: Coordinate.ViewModel.Element.Lines) {
        for line in viewModel.params {
                mapView.addOverlay(line)
        }
    }
    
    func updateLabel(viewModel: Coordinate.ViewModel.Element.Distance) {
        label.text = viewModel.value
    }
    
    // Добавляем констейнты для карты на экране
    private func addConstraint() {
        self.view.addSubview(self.mapView)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mapView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        // Добавляем view Длина границы поверх карты
        view.addSubview(label)
        
    }
    

}

extension CoordinateViewController: MKMapViewDelegate {
    // Отрисовывем на карте линии
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline{
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = color
            renderer.lineWidth = 2.0

            return renderer
        }
        if overlay is MKCircle {
            let render = MKCircleRenderer(overlay: overlay)
            render.strokeColor = .orange
            render.lineWidth = 1.0

            return render
        }
        return MKOverlayRenderer()
    }
}
