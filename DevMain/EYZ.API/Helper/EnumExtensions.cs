using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;

namespace Bussines.Helper
{
    public static class EnumExtensions
    {
        public static IDictionary<int, String> GetEnumList<T>() where T : IConvertible
        {
            return Enum
               .GetValues(typeof(T))
               .Cast<T>()
               .ToDictionary(
                   t => t.ToInt32(CultureInfo.InvariantCulture),
                   t => t.ToString()
               );
        }

        public static List<KeyValuePair<string, int>> GetEnumListKeyValue<T>()
        {
            var list = new List<KeyValuePair<string, int>>();
            foreach (var e in Enum.GetValues(typeof(T)))
            {
                list.Add(new KeyValuePair<string, int>(e.ToString(), (int)e));
            }
            return list;
        }
    }
}