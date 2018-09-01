using Vessel.Services.Rules.Model;
using System;
using System.Collections.Generic;

namespace Vessel.Services.Rules.Interface
{
    public partial interface IVessel
    {
        IList<dynamic> DB_Vessel_List(int PageIndex, int PageSize, int Owner, out int TotalRecords);

        VesselModel DB_Vessel_Get(Guid Token);

        VesselModel DB_Vessel_Get(int Id);

        void DB_Vessel_Delete(Guid Token);

        void DB_Vessel_StatusUpdate(Guid Token, bool IsActive, int UpdatedId);

        void DB_Vessel_Save(Guid Token, string Name, string Description, string Phone,
                             string Email, string Contact, int CityId, float Speed, int TypeId,
                             int Capacity, float Demurrage, float RateLoading, float RateUnloading, float IfoConsumed,
                             float MgoConsumed, string Products, string Property, bool IsActive, int Owner, int UpdatedId);

        IList<dynamic> DB_VesselChange_Save(Guid Token, float DailyHire, int UpdatedId);
    }
}