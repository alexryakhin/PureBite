import class Combine.AnyCancellable

protocol AnyServiceObserver: AnyObject {
    func errorReceived(_ error: Error, contentPreserved: Bool, action: @escaping VoidHandler)
}

protocol ServiceObserver: AnyServiceObserver {
    associatedtype ContentModel

    func contentModelReceived(_ contentModel: ContentModel)
    func loadingStarted()
}

extension ServiceObserver {

    func observe<S>(service: S) -> AnyCancellable where S: ContentObserverInterface, S.Content == ContentModel {
        return service.observe { [weak self] loaderState in
            self?.handle(loaderState: loaderState)
        }
    }

    func handle(loaderState state: LoaderState<ContentModel>) {
        if let content = state.content {
            contentModelReceived(content)
            if let error = state.error {
                errorReceived(error, contentPreserved: true, action: {})
            }
        } else {
            if state.isLoading {
                loadingStarted()
            } else if let error = state.error {
                errorReceived(error, contentPreserved: false, action: {
                    print("DEBUG: Retrying recipe details load")
                })
            }
        }
    }
}
