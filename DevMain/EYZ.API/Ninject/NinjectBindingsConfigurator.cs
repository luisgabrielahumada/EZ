using Auth.Rules.Interface.Task;
using Auth.Rules.Services;
using Conditions.Services.Rules.Interface;
using Conditions.Services.Rules.Task;
using Configurations.Rules.Interface.Task;
using Configurations.Rules.Services;
using Ninject;
using Ports.Services.Rules.Interface;
using Ports.Services.Rules.Task;
using Products.Services.Rules.Interface;
using Products.Services.Rules.Task;
using Quantity.Services.Rules.Interface;
using Quantity.Services.Rules.Task;
using Request.Services.Rules.Interface;
using Request.Services.Rules.Task;
using StowageFactors.Services.Rules.Interface;
using StowageFactors.Services.Rules.Task;
using System.Configuration;
using System.Web.Http;
using System.Web.Http.Dispatcher;
using Terminals.Services.Rules.Interface;
using Terminals.Services.Rules.Task;
using Tolerances.Services.Rules.Interface;
using Tolerances.Services.Rules.Task;
using Vessel.Services.Rules.Interface;
using Vessel.Services.Rules.Task;

namespace Business.Domine.ServiceLocation
{
    public static class NinjectBindingsConfigurator
    {
        private static StandardKernel _kernel;

        public static void Start()
        {
            _kernel = new StandardKernel();

            _kernel.Bind<IHttpControllerActivator>()
                   .To<NinjectKActivator>()
                   .InSingletonScope()
                   .WithConstructorArgument("kernel", _kernel);
            _kernel.Bind<ICitieTask>().To<CitiesServices>().WithConstructorArgument("connectionString", ConfigurationManager.ConnectionStrings["ConnectionString.Business.Web"].ConnectionString);
            _kernel.Bind<ICommonsTask>().To<CommonsServices>().WithConstructorArgument("connectionString", ConfigurationManager.ConnectionStrings["ConnectionString.Business.Web"].ConnectionString);
            _kernel.Bind<ICountriesTask>().To<CountriesServices>().WithConstructorArgument("connectionString", ConfigurationManager.ConnectionStrings["ConnectionString.Business.Web"].ConnectionString);
            _kernel.Bind<IParametersTask>().To<ParametersServices>().WithConstructorArgument("connectionString", ConfigurationManager.ConnectionStrings["ConnectionString.Business.Web"].ConnectionString);
            _kernel.Bind<ISmtpTask>().To<SmtpServices>().WithConstructorArgument("connectionString", ConfigurationManager.ConnectionStrings["ConnectionString.Business.Web"].ConnectionString);
            _kernel.Bind<IMenusTask>().To<MenusServices>().WithConstructorArgument("connectionString", ConfigurationManager.ConnectionStrings["ConnectionString.Business.Web"].ConnectionString);
            _kernel.Bind<IPermissionsTask>().To<PermissionsServices>().WithConstructorArgument("connectionString", ConfigurationManager.ConnectionStrings["ConnectionString.Business.Web"].ConnectionString);
            _kernel.Bind<IProfilesTask>().To<ProfilesServices>().WithConstructorArgument("connectionString", ConfigurationManager.ConnectionStrings["ConnectionString.Business.Web"].ConnectionString);
            _kernel.Bind<IUsersTask>().To<UsersServices>().WithConstructorArgument("connectionString", ConfigurationManager.ConnectionStrings["ConnectionString.Business.Web"].ConnectionString);
            _kernel.Bind<IAccesUsersTask>().To<AuthServices>().WithConstructorArgument("connectionString", ConfigurationManager.ConnectionStrings["ConnectionString.Business.Web"].ConnectionString);
            _kernel.Bind<IMessageLogTask>().To<MessageLogServices>().WithConstructorArgument("connectionString", ConfigurationManager.ConnectionStrings["ConnectionString.Business.Web"].ConnectionString);
            _kernel.Bind<IProductsTask>().To<ProductServices>().WithConstructorArgument("connectionString", ConfigurationManager.ConnectionStrings["ConnectionString.Business.Web"].ConnectionString);
            _kernel.Bind<IPortsTask>().To<PortServices>().WithConstructorArgument("connectionString", ConfigurationManager.ConnectionStrings["ConnectionString.Business.Web"].ConnectionString);
            _kernel.Bind<IConditionsTask>().To<ConditionServices>().WithConstructorArgument("connectionString", ConfigurationManager.ConnectionStrings["ConnectionString.Business.Web"].ConnectionString);
            _kernel.Bind<IQuantityTask>().To<QuantityServices>().WithConstructorArgument("connectionString", ConfigurationManager.ConnectionStrings["ConnectionString.Business.Web"].ConnectionString);
            _kernel.Bind<IStowageFactorsTask>().To<StowageFactorServices>().WithConstructorArgument("connectionString", ConfigurationManager.ConnectionStrings["ConnectionString.Business.Web"].ConnectionString);
            _kernel.Bind<ITolerancesTask>().To<ToleranceServices>().WithConstructorArgument("connectionString", ConfigurationManager.ConnectionStrings["ConnectionString.Business.Web"].ConnectionString);
            _kernel.Bind<ITerminalsTask>().To<TerminalServices>().WithConstructorArgument("connectionString", ConfigurationManager.ConnectionStrings["ConnectionString.Business.Web"].ConnectionString);
            _kernel.Bind<IRequestTask>().To<RequestServices>().WithConstructorArgument("connectionString", ConfigurationManager.ConnectionStrings["ConnectionString.Business.Web"].ConnectionString);
            _kernel.Bind<IVesselTask>().To<VesselServices>().WithConstructorArgument("connectionString", ConfigurationManager.ConnectionStrings["ConnectionString.Business.Web"].ConnectionString);
            _kernel.Bind<IPropertyVesselTask>().To<PropertyVesselServices>().WithConstructorArgument("connectionString", ConfigurationManager.ConnectionStrings["ConnectionString.Business.Web"].ConnectionString);
            GlobalConfiguration.Configuration.DependencyResolver = new LoadNinjectResolver(
                _kernel, GlobalConfiguration.Configuration.DependencyResolver
            );
        }
    }
}