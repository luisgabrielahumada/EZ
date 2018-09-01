using Products.Services.Rules.Model;
using System;
using System.Collections.Generic;
using Vessel.Services.Rules.Model;

namespace Vessel.Services.Rules.Interface
{
    public interface IVesselTask
    {
        void Save(Guid Token, string Name, string Description, string Phone,
                 string Email, string Contact, int CityId, float Speed, int TypeId,
                 int Capacity, float Demurrage, float RateLoading, float RateUnloading, float IfoConsumed,
                 float MgoConsumed, List<ProductModel> Products, List<PropertyVesselModel> Property, bool IsActive, int UpdatedId);

        IList<dynamic> Get(int PageIndex, int PageSize, int Owner, out int TotalRecords);

        VesselModel GetToken(Guid Token);

        VesselModel Get(int Id);

        void Delete(Guid Token, int UpdatedId);

        void Remove(Guid Token, bool IsActive, int UpdatedId);

        void AddAvailableOpenVessels(Guid Token, DateTime NextOpeningOn, DateTime NextOpeningPort, int CurrentPortId, int CurrentTerminalId, int UpdatedId);

        void RemoveAvailable(Guid Token, int UpdatedId);

        dynamic AvailableOpenVessels(Guid Token, int UpdatedId);

        IList<dynamic> Changes(Guid Token, float DailyHire, int UpdatedId);

        Tuple<IList<ProductModel>, IList<ProductModel>> GetVesselProductAssigned(Guid? Token);

        void UpdateRequestForThisVessel(Guid Token, int UpdatedId);
    }
}