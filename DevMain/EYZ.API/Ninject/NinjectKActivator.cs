using Ninject;
using System;
using System.Linq;
using System.Net.Http;
using System.Web.Http.Controllers;
using System.Web.Http.Dispatcher;

namespace Business.Domine.ServiceLocation
{
    public class NinjectKActivator : IHttpControllerActivator
    {
        private readonly IKernel _kernel;

        public NinjectKActivator(IKernel kernel)
        {
            _kernel = kernel;
        }

        public IHttpController Create(HttpRequestMessage request, HttpControllerDescriptor controllerDescriptor, Type controllerType)
        {
            if (!_kernel.GetBindings(controllerType).Any())
                _kernel.Bind(controllerType).ToSelf();

            var controller = (IHttpController)(_kernel.GetAll(controllerType).FirstOrDefault());

            request.RegisterForDispose(new Release(() => _kernel.Release(controller)));

            return controller;
        }
    }

    internal class Release : IDisposable
    {
        private readonly Action _release;

        public Release(Action release)
        {
            _release = release;
        }

        public void Dispose()
        {
            _release();
        }
    }
}