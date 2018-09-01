using Gesi.Access.Database;
using Insight.Database;
using System;
using System.Collections.Generic;
using Vessel.Services.Rules.Interface;
using Vessel.Services.Rules.Model;

namespace Vessel.Services.Rules.Task
{
    public class PropertyVesselServices : IPropertyVesselTask
    {
        public void Delete(Guid Token, int UpdatedId)
        {
            Database.CurrentCnn.As<IPropertyVessel>().DB_PropertyVessel_Delete(Token);
        }

        public IList<PropertyVesselModel> Get(int PageIndex, int PageSize, out int TotalRecords)
        {
            return Database.CurrentCnn.As<IPropertyVessel>().DB_PropertyVessel_List(PageIndex, PageSize, out TotalRecords);
        }

        public PropertyVesselModel Get(Guid Token)
        {
            return Database.CurrentCnn.As<IPropertyVessel>().DB_PropertyVessel_Get(Token);
        }

        public IList<PropertyVesselModel> PropertyToVessel(Guid? Token, int UpdatedId, int Owner)
        {
            return Database.CurrentCnn.As<IPropertyVessel>().DB_PropertyToVessel_List(Token, UpdatedId, Owner);
        }

        public void Remove(Guid Token, bool IsActive, int UpdatedId)
        {
            Database.CurrentCnn.As<IPropertyVessel>().DB_PropertyVessel_StatusUpdate(Token, IsActive, UpdatedId);
        }

        public void Save(Guid Token, string Name, string Code, bool IsActive, int UpdatedId)
        {
            Database.CurrentCnn.As<IPropertyVessel>().DB_PropertyVessel_Save(Token, Name, Code, IsActive, UpdatedId);
        }
    }
}