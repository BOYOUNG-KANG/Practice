# 📍 Terraform

---
## 📌 terraform 이란?

- IaC(Infrastructure as code), 말그대로 aws나 azure에서 하던 인프라 구성을 코드로 한다.
- HashiCorp에서 만들었다.
- HCL(HashiCorp Configuration Language)이라는 언어 이용해서 테라폼 스크립트 짜고, 명령어 이용해서 코드를 실행하면 테라폼은 코드에 따라 인프라스트럭처를 프로비저닝한다.

## 📌 terraform command
### terraform 주요 명령어
    # initialize terraform
    terraform init

    # review the configuration
    terraform plan
    
    # apply the configuration
    terraform apply

    # remove the configuration
    terraform deploy
### 그렇게 주요하진 않지만 쓸 수도 있는 명령어
    # validate the syntax
    terraform validate

    # pretty format
    terraform fmt

    # show all the meta information
    terraform show

    # show providers
    terraform providers

    # show in graph(you need to install graphviz)
    terraform graph
    terraform graph | dot -Tsvg > sample.svg

## 📌 구성한 인프라 설명
### IAM
- AdministratorAccess 권한을 가진 admin과 ReadOnlyAccess 권한을 가진 viewer를 developer_group에 넣었다.
### S3
- s3의 경우 버킷의 접근 권한을 제어하는 방식을 IAM policy를 이용하냐 bucket public access block이냐에 따라 구분하여 구성했다.
  - 다만, ‘BucketAlreadyExists’라는 에러가 뜨는데, 버킷 이름은 전 세계적으로 고유해야 하기 때문에 이미 사용 중인 이름 선택 시에 충돌이 발생할 수 있어서 고유한 이름 짓는 부분이 까다로운 것 같다.
  - aws 콘솔에서는 버킷 생성 전에 경고 메시지를 보내주는데 테라폼에서는 terraform apply하고 나서 오류 메시지로 중복 여부를 알 수 있어서 상대적으로 불편했다. 그래서 s3는 테라폼보다 aws 콘솔을 이용하는 것이 더 편했다.
### VPC
- vpc 안에 public subnet과 private subnet으로 구성했다.
- public subnet은 IGW를 통해 외부와 통신할 수 있고, private subnet에서도 NAT gateway를 통해 IGW로 나갈 수 있도록 구성했다.
