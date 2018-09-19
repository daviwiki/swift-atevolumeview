
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
        sliderLayer = getSliderShapeLayer()
        layer.addSublayer(sliderLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.bezierPath = UIBezierPath()
        super.init(coder: aDecoder)
        sliderLayer = getSliderShapeLayer()
        layer.addSublayer(sliderLayer)
    }
    
    /**
    Create the shape layers that will draw the volume bar
    */
    private func getSliderShapeLayer() -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = foregroundColor.cgColor
        shapeLayer.lineWidth = SliderVolumeView.lineWidth
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.strokeStart = 0.0
        shapeLayer.fillColor = UIColor.clear.cgColor
        return shapeLayer
    }

    /**
     Set the bezier path that will be assigned to the shape
     */
    func setSlider(bezierPath: UIBezierPath) {
        self.bezierPath = bezierPath
        sliderLayer.path = bezierPath.cgPath
        setStrokeWidth(value: currentValue)
    }
    
    /**
     Set value between [0, 1] that represents percent of slider filled
     - Parameter value: percent value in [0, 1]
    */
    func setSliderPercent(value: Float) {
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
