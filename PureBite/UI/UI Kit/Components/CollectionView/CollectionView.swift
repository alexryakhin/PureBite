import SwiftUI

// swiftlint: disable all
public struct CollectionRow<Section: Hashable, Item: Hashable>: Hashable {
    let section: Section
    let items: [Item]

    public init(section: Section, items: [Item]) {
        self.section = section
        self.items = items
    }
}

public struct CollectionView<Section: Hashable, Item: Hashable, Cell: View>: UIViewRepresentable {
    private class HostCell: UICollectionViewCell {
        private var hostController: UIHostingController<Cell>?

        override func prepareForReuse() {
            if let hostView = hostController?.view {
                hostView.removeFromSuperview()
            }
            hostController = nil
        }

        var hostedCell: Cell? {
            willSet {
                guard let view = newValue else { return }
                hostController = UIHostingController(rootView: view)
                if let hostView = hostController?.view {
                    hostView.frame = contentView.bounds
                    hostView.backgroundColor = .clear
                    hostView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    contentView.addSubview(hostView)
                }
            }
        }
    }

    public class Coordinator: NSObject, UICollectionViewDelegate,UIScrollViewDelegate {
        fileprivate typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>

        fileprivate var dataSource: DataSource?
        fileprivate var rowsHash: Int?
        fileprivate var isFocusable: Bool = false

        let onCellTap: IntHandler
        let itemSize: CGSize
        @Binding var contentOffset: CGPoint

        init(
            contentOffset: Binding<CGPoint>,
            itemSize: CGSize,
            onCellTap: @escaping IntHandler
        ) {
            self.onCellTap = onCellTap
            self.itemSize = itemSize
            self._contentOffset = contentOffset
        }

        public func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
            return isFocusable
        }

        public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            onCellTap(indexPath.row)
        }

        public func scrollViewDidScroll(_ scrollView: UIScrollView) {
            contentOffset = scrollView.contentOffset
        }
    }

    let rows: [CollectionRow<Section, Item>]
    let itemSize: CGSize
    let cell: (IndexPath, Item) -> Cell
    let onCellTap: IntHandler
    @Binding var contentOffset: CGPoint

    public init(
        rows: [CollectionRow<Section, Item>],
        itemSize: CGSize,
        onCellTap: @escaping IntHandler,
        contentOffset: Binding<CGPoint>,
        @ViewBuilder cell: @escaping (IndexPath, Item) -> Cell
    ) {
        self.rows = rows
        self.itemSize = itemSize
        self.cell = cell
        self.onCellTap = onCellTap
        self._contentOffset = contentOffset
    }

    private func snapshot() -> NSDiffableDataSourceSnapshot<Section, Item> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        for row in rows {
            snapshot.appendSections([row.section])
            snapshot.appendItems(row.items, toSection: row.section)
        }
        return snapshot
    }

    private func reloadData(in collectionView: UICollectionView, context: Context, animated: Bool = false) {
        let coordinator = context.coordinator

        guard let dataSource = coordinator.dataSource else { return }

        let rowsHash = rows.hashValue
        if coordinator.rowsHash != rowsHash {
            dataSource.apply(snapshot(), animatingDifferences: animated) {
                coordinator.isFocusable = true
                collectionView.setNeedsFocusUpdate()
                collectionView.updateFocusIfNeeded()
                coordinator.isFocusable = false
            }
            coordinator.rowsHash = rowsHash
        }
    }

    public func makeCoordinator() -> Coordinator {
        return Coordinator(contentOffset: $contentOffset, itemSize: itemSize, onCellTap: onCellTap)
    }

    public func makeUIView(context: Context) -> UICollectionView {
        let cellIdentifier = "hostCell"
        let collectionViewFlowLayout = CollectionViewFlowLayout(itemSize: itemSize, onCellTap: onCellTap)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.delegate = context.coordinator
        collectionView.register(HostCell.self, forCellWithReuseIdentifier: cellIdentifier)

        let dataSource = Coordinator.DataSource(collectionView: collectionView) { collectionView, indexPath, item in
            let hostCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? HostCell
            hostCell?.hostedCell = cell(indexPath, item)
            return hostCell
        }
        context.coordinator.dataSource = dataSource
        collectionView.decelerationRate = .fast
        collectionView.backgroundColor = .clear
        reloadData(in: collectionView, context: context)
        return collectionView
    }

    public func updateUIView(_ uiView: UICollectionView, context: Context) {
        uiView.frame = uiView.frame
        uiView.reloadData()
        reloadData(in: uiView, context: context, animated: false)
    }
}
