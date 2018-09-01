using Gesi.Access.Database;
using Insight.Database;
using Products.Services.Rules.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Vessel.Services.Rules.Interface;
using Vessel.Services.Rules.Model;

namespace Vessel.Services.Rules.Task
{
    public class VesselServices : IVesselTask
    {
        public void AddAvailableOpenVessels(Guid Token, DateTime NextOpeningOn, DateTime NextOpeningPort, int CurrentPortId, int CurrentTerminalId, int UpdatedId)
        {
            Database.CurrentCnn.As<IAvailableOpenVessels>().DB_AvailableOpenVessels_Save(Token, NextOpeningOn, NextOpeningPort, CurrentPortId, CurrentTerminalId, UpdatedId);
        }

        public void Delete(Guid Token, int UpdatedId)
        {
            Database.CurrentCnn.As<IAvailableOpenVessels>().DB_AvailableOpenVessels_Delete(Token);
        }

        public dynamic AvailableOpenVessels(Guid Token, int UpdatedId)
        {
            return Database.CurrentCnn.As<IAvailableOpenVessels>().DB_AvailableOpenVessels_Get(Token);
        }

        public IList<dynamic> Get(int PageIndex, int PageSize, int Owner, out int TotalRecords)
        {
            return Database.CurrentCnn.As<IVessel>().DB_Vessel_List(PageIndex, PageSize, Owner, out TotalRecords);
        }

        public VesselModel Get(int Id)
        {
            return Database.CurrentCnn.As<IVessel>().DB_Vessel_Get(Id);
        }

        public VesselModel GetToken(Guid Token)
        {
            return Database.CurrentCnn.As<IVessel>().DB_Vessel_Get(Token);
        }

        public void Remove(Guid Token, bool IsActive, int UpdatedId)
        {
            Database.CurrentCnn.As<IVessel>().DB_Vessel_StatusUpdate(Token, IsActive, UpdatedId);
        }

        public void RemoveAvailable(Guid Token, int UpdatedId)
        {
            throw new NotImplementedException();
        }

        public void Save(Guid Token, string Name, string Description, string Phone,
                             string Email, string Contact, int CityId, float Speed, int TypeId,
                             int Capacity, float Demurrage, float RateLoading, float RateUnloading, float IfoConsumed,
                             float MgoConsumed, List<ProductModel> Products, List<PropertyVesselModel> Property, bool IsActive, int UpdatedId)

        {
            Database.CurrentCnn.As<IVessel>().DB_Vessel_Save(Token, Name, Description, Phone, Email, Contact, CityId, Speed, TypeId, Capacity, Demurrage, RateLoading, RateUnloading, IfoConsumed, MgoConsumed,
                                                            string.Join(",", Products.Select(m => m.Id).ToArray()), string.Join("?", Property.Select(m => $"{m.PropertyVesselId}|{m.Value}").ToArray()), IsActive, UpdatedId, UpdatedId);
        }

        public IList<dynamic> Changes(Guid Token, float DailyHire, int UpdatedId)
        {
           return Database.CurrentCnn.As<IVessel>().DB_VesselChange_Save(Token, DailyHire, UpdatedId);
        }

        public Tuple<IList<ProductModel>, IList<ProductModel>> GetVesselProductAssigned(Guid? Token)
        {
            var results = Database.CurrentCnn.QueryResults<ProductModel, ProductModel>("DB_VesselProduct_Assigned", new { Token = Token });
            var byAssigned = results.Set1;
            var Assigned = results.Set2;
            return Tuple.Create(byAssigned, Assigned);
        }

        public void UpdateRequestForThisVessel(Guid Token, int UpdatedId)
        {
            Database.CurrentCnn.QueryResults<ProductModel, ProductModel>("DB_UpdateRequestForThisVessel", new { Token = Token, UpdatedId = UpdatedId });
        }
    }
}