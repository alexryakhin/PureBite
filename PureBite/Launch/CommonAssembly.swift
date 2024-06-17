import Swinject

final class CommonAssembly: Assembly, Identifiable {

    let id = "CommonAssembly"

    func assemble(container: Container) {

        container.register(WebViewController.self) { (_, link: String, title: String) in
            return WebViewController(with: link, title: title)
        }.inObjectScope(.transient)

        container.autoregister(UnderDevelopmentController.self, initializer: UnderDevelopmentController.init)
    }
}
