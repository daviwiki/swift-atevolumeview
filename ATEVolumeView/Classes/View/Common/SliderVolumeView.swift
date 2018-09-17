
import UIKit

class SliderVolumeView: UIView {

    static let lineWidth: CGFloat = 4
    
    // Path that define points where volume stroke will pass
    private var bezierPath: UIBezierPath
    
    // Percent painted in range [0, 1]
    private var sliderLayer: CAShapeLayer!

    // Current volume Value
    private var currentValue: CGFloat = 0.0

    // Stroke color for volume var
    var foregroundColor: UIColor = UIColor.clear {
        didSet {
            sliderLayer.strokeColor = foregroundColor.cgColor
        }
    }

    init(bezierPath: UIBezierPath) {
        self.bezierPath = bezierPath
        super.init(frame: .zero)
        createLayers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        createLayers()
    }

    /**
    Create the shape layers that will draw the volume bar
    */
    private func createLayers() {
        layer.sublayers?.forEach({ $0.removeFromSuperlayer() })
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bezierPath.cgPath
        shapeLayer.strokeColor = foregroundColor.cgColor
        shapeLayer.lineWidth = SliderVolumeView.lineWidth
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.strokeStart = 0.0
        shapeLayer.fillColor = UIColor.clear.cgColor
        setStrokeWidth(value: currentValue)

        layer.addSublayer(shapeLayer)
        sliderLayer = shapeLayer
    }

    /**
    Set value between [0, 1]
    */
    func set(value: Float, animated: Bool = false) {
        let cgValue: CGFloat = min(max(0, CGFloat(value)), 1)
        self.currentValue = cgValue
        setStrokeWidth(value: cgValue)
    }

    private func setStrokeWidth(value: CGFloat) {
        guard self.frame.width > 0 else { return }
        let minValue = (SliderVolumeView.lineWidth / 2) / self.frame.width
        sliderLayer.strokeEnd = max(value, minValue)
    }
}
