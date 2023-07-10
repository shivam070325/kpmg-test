def get_nested_value(obj, key):
    keys = key.split('/')  
    try:
        for k in keys:
            obj = obj[k]
        return obj
    except KeyError:
        return None

 

object1 = {"a": {"b": {"c": "d"}}}
key1 = "a/b/c"
value1 = get_nested_value(object1, key1)
object2 = {"x": {"y": {"z": "a"}}}
key2 = "x/y/z"
value2 = get_nested_value(object2, key2)
print(value2)