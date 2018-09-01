using Ninject;
using System;
using System.Collections.Generic;
using System.Web.Http.Dependencies;

namespace EYZ.Infrastructure
{
    internal class LoadNinjectResolver : IDependencyResolver
    {
        private readonly KernelBase _kernel;

        private readonly IDependencyResolver _defaultResolver;

        public LoadNinjectResolver(KernelBase configuredKernel, IDependencyResolver defaultResolver)
        {
            _kernel = configuredKernel;
            _defaultResolver = defaultResolver;
        }

        public IDependencyScope BeginScope()
        {
            return this;
        }

        public void Dispose()
        {
            _kernel.Dispose();
        }

        public object GetService(Type serviceType)
        {
            return _kernel.TryGet(serviceType) ?? _defaultResolver.GetService(serviceType);
        }

        public IEnumerable<object> GetServices(Type serviceType)
        {
            try
            {
                return _kernel.GetAll(serviceType);
            }
            catch
            {
                return _defaultResolver.GetServices(serviceType);
            }
        }
    }
}