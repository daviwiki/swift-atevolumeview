
import UIKit

class SliderVolumeView: UIView {

    private static let lineWidth: CGFloat = 4

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

    override init(frame: CGRect) {
        super.init(frame: frame)
        createLayers()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createLayers()
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

        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: SliderVolumeView.lineWidth/2))
        path.addLine(to: CGPoint(x: self.frame.width, y: SliderVolumeView.lineWidth/2))

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = foregroundColor.cgColor
        shapeLayer.lineWidth = SliderVolumeView.lineWidth
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.strokeStart = 0.0
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
