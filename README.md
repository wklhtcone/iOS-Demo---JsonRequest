## 1. 简介
### 1.1 一个获取日出日落时间的API网站
- [Sunset and sunrise times API](https://sunrise-sunset.org/api)
- 提供API，为给定的经纬度提供日出日落时间等
### 1.2 效果
- URL：`https://api.sunrise-sunset.org/json?lat=36.7201600&lng=-4.4203400`
- 返回的Json数据

```javascript
 {"results":
    {"sunrise":"7:14:21 AM",
    "sunset":"5:49:11 PM",
    "solar_noon":"12:31:46 PM",
    "day_length":"10:34:50",
    "civil_twilight_begin":"6:47:33 AM",
    "civil_twilight_end":"6:15:59 PM",
    "nautical_twilight_begin":"6:16:53 AM",
    "nautical_twilight_end":"6:46:39 PM",
    "astronomical_twilight_begin":"5:46:38 AM",
    "astronomical_twilight_end":"7:16:54 PM"},
 "status":"OK"}
```

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210207002229845.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1MDg3NDI1,size_16,color_FFFFFF,t_70)
- `response`和`data`：
![在这里插入图片描述](https://img-blog.csdnimg.cn/20210206233609154.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1MDg3NDI1,size_16,color_FFFFFF,t_70)
## 2. 获取Json并解析
### 2.1 数据结构
1. 整个Json看作一个自定义结构体`RevData`
- key是`"results"`，value是一个自定义的结构体`MyResult`
- key是`"status"`，value是`String`类型
2. `MyResult`结构体
- 存了一组key-value值，value为`String`类型
3. 两个结构体都要遵守`Codable`协议
- Swift 4引入了`Codable`协议，与`NSCoding`协议不同的是：如果自定义的类中全都是基本数据类型、基本对象类型，它们都已经实现了`Codable`协议，那么这个自定义的类也默认实现了`Codable`，无需再实现编解码，只需要在自定义的类声明它遵守`Codable`协议即可

```swift
struct RevData: Codable {
    let results: MyResult
    let status: String
}

struct MyResult: Codable {
    let sunrise: String
    let sunset: String
    let solar_noon: String
    let day_length: String
    let civil_twilight_begin: String
    let civil_twilight_end: String
    let nautical_twilight_begin: String
    let nautical_twilight_end: String
    let astronomical_twilight_begin: String
    let astronomical_twilight_end: String
}
```

### 2.2 URLSession获取Json并解析

1. 对于基本请求可以使用`URLSession.shared`单例，简单的数据任务使用`dataTask`方法
![在这里插入图片描述](https://img-blog.csdnimg.cn/20210207000007482.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1MDg3NDI1,size_16,color_FFFFFF,t_70)
2. `dataTask(with: URL, completionHandler: (Data?, URLResponse?, Error?) -> Void)`方法
- 获取数据成功时，数据保存在`Data`，`Error`为nil
- 获取失败时，`Error`不为nil
- 不论是否获取成功，`URLResponse`不为nil，存着HTTP响应报文中的数据![在这里插入图片描述](https://img-blog.csdnimg.cn/20210207000649837.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1MDg3NDI1,size_16,color_FFFFFF,t_70)
3. 数据可能获取失败，因此用`guard ... else`处理

```swift
 guard let data = data, error == nil else{
     print("URL获取数据失败")
     return
 }
```
4. 获取data后将其转为结构体
- `JSONDecoder().decode()`可能失败`throw`异常，因此放在`do{} catch{}`中，并`try`
- 若转换失败，`revData`就成了`nil`，因此声明为可选型

```swift
var revData: RevData?
do{
    revData = try JSONDecoder().decode(RevData.self, from: data)
}
catch{
    print("Json转struct失败\(error)")
}
```
## 3. 完整代码

```swift
override func viewDidLoad() {
    super.viewDidLoad()
    let url = "https://api.sunrise-sunset.org/json?lat=36.7201600&lng=-4.4203400"
    getData(from: url)
}


func getData(from url: String){
    let session = URLSession.shared
    let task = session.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
        guard let data = data, error == nil else{
            print("URL获取数据失败")
            return
        }

        //获取到了数据
        print(response!)
        var revData: RevData?
        do{
            revData = try JSONDecoder().decode(RevData.self, from: data)
        }
        catch{
            print("Json转struct失败\(error)")
        }
        print(revData!.results)
        print(revData!.status)
        
    })
    task.resume()
}
```


