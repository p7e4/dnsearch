package main

import (
    "github.com/kataras/iris/v12"
    "go.mongodb.org/mongo-driver/mongo"
    "go.mongodb.org/mongo-driver/bson"
    "go.mongodb.org/mongo-driver/mongo/options"

    "log"
    "context"
    "strings"
)

func Reverse(s interface{}) string {
    r := []rune(s.(string))
    for i, j := 0, len(r)-1; i < j; i, j = i+1, j-1 {
        r[i], r[j] = r[j], r[i]
    }
    return string(r)
}

func main() {
    client, err := mongo.Connect(context.TODO(), options.Client().ApplyURI("mongodb://localhost:27017"))
    if err != nil {
        log.Fatal(err)
    }
    defer func() {
        if err = client.Disconnect(context.TODO()); err != nil {
            log.Fatal(err)
        }
    }()

    collection := client.Database("dns").Collection("dns")

    app := iris.New()

    app.Get("/", func(ctx iris.Context) {
        domain := strings.ReplaceAll(Reverse(strings.ToLower(ctx.URLParam("domain"))), ".", "\\.")
        ip := Reverse(ctx.URLParam("ip"))

        var data []interface{}

        if len(domain) > 0 {
            if domain[len(domain)-1:] != "." {
                domain = domain + "\\."
            }
            opts := options.Distinct()

            values, _ := collection.Distinct(context.TODO(), "domain", bson.D{{"domain", bson.M{"$regex": "^" + domain}}}, opts)
            for _, value := range values {
                data = append(data, Reverse(value))
            }

        } else if len(ip) > 0 {
            cursor, err := collection.Find(context.TODO(), bson.D{{"ip", ip}})
            if err != nil {
                log.Fatal(err)
            }

            var values []bson.M
            if err = cursor.All(context.TODO(), &values); err != nil {
                log.Fatal(err)
            }

            for _, value := range values {
                data = append(data, Reverse(value["domain"]))
            }

        } else {
            ctx.WriteString("OK!")
            return
        }

        if len(data) == 0 {
            ctx.JSON([]string{})
        } else {
            ctx.JSON(data)
        }

    })

    app.Listen(":80")
}
