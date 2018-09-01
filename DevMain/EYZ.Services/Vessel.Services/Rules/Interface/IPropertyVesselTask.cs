using System;
using System.Collections.Generic;
using Vessel.Services.Rules.Model;

namespace Vessel.Services.Rules.Interface
{
    public interface IPropertyVesselTask
    {
        void Save(Guid Token, String Name, String Code, bool IsActive, int UpdatedId);

        IList<PropertyVesselModel> Get(int PageIndex, int PageSize, out int TotalRecords);

        PropertyVesselModel Get(Guid Token);

        void Delete(Guid Token, int UpdatedId);

        void Remove(Guid Token, bool IsActive, int UpdatedId);

        IList<PropertyVesselModel> PropertyToVessel(Guid? Token, int UpdatedId, int Owner);
    }
}