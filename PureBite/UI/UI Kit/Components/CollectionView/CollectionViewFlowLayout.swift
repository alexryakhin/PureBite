import SwiftUI

final class CollectionViewFlowLayout: UICollectionViewFlowLayout {
    private let scaleDownFactor: CGFloat = 0.85

    let onCellTap: IntHandler

    public init(
        itemSize: CGSize,
        onCellTap: @escaping IntHandler
    ) {
        self.onCellTap = onCellTap
        super.init()
        self.itemSize = itemSize
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepare() {
        guard let collectionView = collectionView else { fatalError("no collection view") }
        collectionView.showsHorizontalScrollIndicator = false
        let verticalInsets = (collectionView.frame.height - collectionView.adjustedContentInset.top - collectionView.adjustedContentInset.bottom - itemSize.height) / 2
        let horizontalInsets = (collectionView.frame.width - collectionView.adjustedContentInset.right - collectionView.adjustedContentInset.left - itemSize.width) / 2
        sectionInset = UIEdgeInsets(top: verticalInsets, left: horizontalInsets, bottom: verticalInsets, right: horizontalInsets)
        super.prepare()
        scrollDirection = .horizontal
        minimumInteritemSpacing = 0
        minimumLineSpacing = -20
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = collectionView else {
            return nil
        }

        let centerX = collectionView.contentOffset.x + collectionView.bounds.width / 2.0

        if let attributes = super.layoutAttributesForElements(in: rect) {
            for attribute in attributes {
                let distance = abs(attribute.center.x - centerX)
                let scale = max(1 - (distance / collectionView.bounds.width), scaleDownFactor)
                attribute.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
            return attributes
        }

        return nil
    }

    override public func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return .zero }

        // Add some snapping behavior so that the zoomed cell is always centered
        let targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView.frame.width, height: collectionView.frame.height)
        guard let rectAttributes = super.layoutAttributesForElements(in: targetRect) else { return .zero }

        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        let horizontalCenter = proposedContentOffset.x + collectionView.frame.width / 2

        for layoutAttributes in rectAttributes {
            let itemHorizontalCenter = layoutAttributes.center.x
            if (itemHorizontalCenter - horizontalCenter).magnitude < offsetAdjustment.magnitude {
                offsetAdjustment = itemHorizontalCenter - horizontalCenter
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let point = CGPointMake(
                collectionView.center.x + collectionView.contentOffset.x,
                collectionView.center.y + collectionView.contentOffset.y
            )
            guard let indexPath = collectionView.indexPathForItem(at: point)
            else { return }
            self.onCellTap(indexPath.row)
        }

        return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
    }

    override public func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forBoundsChange: newBounds) as! UICollectionViewFlowLayoutInvalidationContext
        context.invalidateFlowLayoutDelegateMetrics = newBounds.size != collectionView?.bounds.size
        return context
    }

    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutAttributesForItem(at: itemIndexPath)
    }
}
