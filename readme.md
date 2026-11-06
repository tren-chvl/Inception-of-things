 <div align="center">

# ☸️ INCEPTION OF THINGS

### Virtualization • Kubernetes • DevOps 

<br>

<img src="https://raw.githubusercontent.com/kubernetes/kubernetes/master/logo/logo.png" width="180" alt="Kubernetes logo">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<img src="https://www.docker.com/wp-content/uploads/2022/03/Moby-logo.png" width="180" alt="Docker logo">

<br><br>

![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)
![K3s](https://img.shields.io/badge/K3s-FFC61C?style=for-the-badge&logo=k3s&logoColor=black)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Vagrant](https://img.shields.io/badge/Vagrant-1868F2?style=for-the-badge&logo=vagrant&logoColor=white)
![Argo CD](https://img.shields.io/badge/Argo_CD-EF7B4D?style=for-the-badge&logo=argo&logoColor=white)

<br>

**Discovering Kubernetes through virtualization, container orchestration and GitOps.**

</div>

---

# 📖 Description

**Inception of Things (IoT)** is a system administration project focused on discovering and implementing Kubernetes infrastructure.

The objective is to understand how to create virtual machines, deploy Kubernetes clusters, expose applications through Ingress, and automate application deployment using GitOps.

The project is divided into three main parts:

- 🖥️ **P1 — K3s and Vagrant:** Create a Kubernetes cluster with one server and one worker.
- ☸️ **P2 — K3s and Applications:** Deploy multiple applications and configure routing with Ingress.
- 🚀 **P3 — K3d and Argo CD:** Create a Kubernetes cluster with K3d and automate deployments using GitOps.

---

# 🏗️ Global Architecture

```text
                    INCEPTION OF THINGS
                            │
             ┌──────────────┼──────────────┐
             │              │              │
             ▼              ▼              ▼
        ┌─────────┐    ┌─────────┐    ┌─────────┐
        │   P1    │    │   P2    │    │   P3    │
        │         │    │         │    │         │
        │  K3s    │    │  K3s    │    │  K3d    │
        │Vagrant  │    │Ingress  │    │ Argo CD │
        └─────────┘    └─────────┘    └─────────┘
             │              │              │
             ▼              ▼              ▼
         Server +       Multiple       GitOps
          Worker       Applications   Deployment
```

---

# 🖥️ Part 1 — K3s and Vagrant
## 🎯 Objective

Create two virtual machines using **Vagrant** and **VirtualBox**, then configure a Kubernetes cluster using **K3s**.

## 🏗️ Architecture

```text
                  VIRTUALBOX
                      │
             ┌────────┴────────┐
             │                 │
             ▼                 ▼
       ┌───────────┐     ┌───────────┐
       │ marchevaS │     │ marchevaSW│
       │           │     │           │
       │ K3s Server│────►│ K3s Agent │
       │           │     │           │
       └───────────┘     └───────────┘
          │                  │
     192.168.56.110     192.168.56.111
```

## ⚙️ Technologies

- 🖥️ Vagrant
- 📦 VirtualBox
- ☸️ K3s
- 🐧 Ubuntu 24.04

## 🚀 Start the virtual machines

```bash
cd p1
vagrant up --no-parallel
```

## 🔍 Connect to the machines

```bash
vagrant ssh marchevaS
```

```bash
vagrant ssh marchevaSW
```

## 🔎 Check the Kubernetes cluster

From the server VM:

```bash
sudo kubectl get nodes -o wide
```

Expected result:

```text
NAME       STATUS   ROLES
marcheva   Ready    control-plane
marchevasw Ready    <none>
```

## 🛑 Stop the virtual machines

```bash
vagrant halt
```

---

# ☸️ Part 2 — K3s and Applications

## 🎯 Objective

Create a K3s cluster and deploy three web applications.

The applications are exposed through **Traefik Ingress**, allowing requests to be routed according to their hostname.

## 🏗️ Architecture

```text
                    BROWSER
                       │
                       ▼
                 ┌───────────┐
                 │  TRAEFIK  │
                 │  INGRESS  │
                 └─────┬─────┘
                       │
           ┌───────────┼───────────┐
           │           │           │
           ▼           ▼           ▼
      ┌─────────┐ ┌─────────┐ ┌─────────┐
      │  APP 1  │ │  APP 2  │ │  APP 3  │
      │         │ │         │ │         │
      │  Nginx  │ │  Nginx  │ │  Nginx  │
      └─────────┘ └─────────┘ └─────────┘
          │           │           │
          ▼           ▼           ▼
       app1.com    app2.com    Default
```

## ⚙️ Technologies

- ☸️ Kubernetes
- 🐳 K3s
- 🌐 Traefik
- 📄 YAML
- 🖥️ Vagrant
- 🌍 Ingress

## 📂 Configuration files

```text
p2/
│
├── Vagrantfile
│
└── confs/
    ├── app1.yaml
    ├── app2.yaml
    ├── app3.yaml
    └── ingress.yaml
```

## 🚀 Deploy the applications

Inside the P2 virtual machine:

```bash
kubectl apply -f confs/app1.yaml
kubectl apply -f confs/app2.yaml
kubectl apply -f confs/app3.yaml
kubectl apply -f confs/ingress.yaml
```

## 🔎 Check the deployments

```bash
kubectl get pods
kubectl get services
kubectl get ingress
```

## 🌐 Test the applications

The Ingress routes requests according to their hostname:

| Hostname | Application |
|---|---|
| `app1.com` | App 1 |
| `app2.com` | App 2 |
| Other hostnames | App 3 |

Example tests from the VM:

```bash
curl -H "Host: app1.com" http://192.168.56.110
curl -H "Host: app2.com" http://192.168.56.110
curl -H "Host: app3.com" http://192.168.56.110
```

---

# 🚀 Part 3 — K3d and Argo CD

## 🎯 Objective

Discover **GitOps** by deploying an application automatically from a public GitHub repository using Argo CD.

K3d runs Kubernetes inside Docker containers, while Argo CD continuously monitors the Git repository and synchronizes the cluster with its configuration.

## 🏗️ Architecture

```text
                  GITHUB REPOSITORY
                 ┌──────────────────┐
                 │                  │
                 │  deployment.yaml │
                 │  service.yaml    │
                 │                  │
                 └────────┬─────────┘
                          │
                          │ GitOps
                          ▼
                  ┌───────────────┐
                  │    ARGO CD    │
                  │               │
                  │  Sync Engine  │
                  └───────┬───────┘
                          │
                          ▼
                   ┌────────────┐
                   │    K3d     │
                   │ Kubernetes │
                   └─────┬──────┘
                         │
                         ▼
                  ┌──────────────┐
                  │     DEV      │
                  │              │
                  │  Playground  │
                  │              │
                  └──────────────┘
```

## ⚙️ Technologies

- 🐳 Docker
- ☸️ Kubernetes
- 🧩 K3d
- 🚀 Argo CD
- 📦 kubectl
- 🌐 GitHub

## 📂 Configuration files

```text
p3/
│
├── scripts/
│   └── install.sh
│
└── confs/
    └── application.yaml
```

## 🛠️ Install the required tools

```bash
cd p3
chmod +x scripts/install.sh
./scripts/install.sh
```

Reconnect to your session after installation to use Docker without `sudo`.

## 🐳 Create the K3d cluster

```bash
k3d cluster create iot-cluster --servers 1 --agents 1
```

Check the nodes:

```bash
kubectl get nodes
```

## 📦 Create the namespaces

```bash
kubectl create namespace argocd
kubectl create namespace dev
```

## 🚀 Install Argo CD

```bash
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

Check the pods:

```bash
kubectl get pods -n argocd
```

## 🔗 Deploy the GitHub application

```bash
kubectl apply -f confs/application.yaml
```

Check the application:

```bash
kubectl get applications -n argocd
```

Expected status:

```text
NAME     SYNC STATUS   HEALTH STATUS
iot-app  Synced        Healthy
```

## 🖥️ Access the Argo CD GUI

Start port forwarding:

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

Open the following URL in your browser:

```text
https://localhost:8080
```

The initial administrator password can be retrieved with:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 -d
```

Login:

```text
Username: admin
Password: <initial-admin-password>
```

## 🌐 Access the application

Start port forwarding:

```bash
kubectl port-forward -n dev svc/playground 8888:8888
```

Open:

```text
http://localhost:8888
```

The application returns a JSON response indicating the deployed version.

## 🔄 GitOps — Version update

The application uses the Docker image `wil42/playground`.

Two versions are used:

| Version | Docker image |
|---|---|
| v1 | `wil42/playground:v1` |
| v2 | `wil42/playground:v2` |

To update the application:

1. Edit `deployment.yaml` in the GitHub repository.
2. Change the image tag from `v1` to `v2`.
3. Commit and push the changes.
4. Argo CD detects the Git change.
5. Argo CD synchronizes the Kubernetes deployment.
6. The application runs the new version.

```text
       GITHUB
          │
          │ Push v2
          ▼
        ARGO CD
          │
          │ Automatic Sync
          ▼
      KUBERNETES
          │
          ▼
    PLAYGROUND v2
```

This demonstrates the GitOps principle: **Git is the source of truth for the deployed application.**

---

# 🧩 Project Structure

```text
Inception-of-things/
│
├── p1/
│   └── Vagrantfile
│
├── p2/
│   ├── Vagrantfile
│   └── confs/
│       ├── app1.yaml
│       ├── app2.yaml
│       ├── app3.yaml
│       └── ingress.yaml
│
└── p3/
    ├── scripts/
    │   └── install.sh
    │
    └── confs/
        └── application.yaml
```

---

# 🆚 Technical Comparisons

## 🖥️ Virtual Machines vs Containers

| Virtual Machines | Containers |
|---|---|
| Virtualize a complete operating system | Share the host kernel |
| Higher resource usage | Lightweight |
| Slower startup | Faster startup |
| Separate guest OS | Isolated processes |

## ☸️ Kubernetes vs K3s vs K3d

| Technology | Purpose |
|---|---|
| Kubernetes | Container orchestration platform |
| K3s | Lightweight Kubernetes distribution |
| K3d | Runs K3s clusters inside Docker |

## 🔄 Traditional Deployment vs GitOps

**Traditional deployment**

```text
Developer
   │
   ▼
Manual kubectl commands
   │
   ▼
Kubernetes Cluster
```

**GitOps deployment**

```text
Developer
   │
   ▼
GitHub Repository
   │
   ▼
Argo CD
   │
   ▼
Kubernetes Cluster
```

GitOps makes deployments easier to track, reproduce and synchronize.

---

# 📚 Resources

### Official documentation

- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [K3s Documentation](https://docs.k3s.io/)
- [K3d Documentation](https://k3d.io/)
- [Docker Documentation](https://docs.docker.com/)
- [Vagrant Documentation](https://developer.hashicorp.com/vagrant/docs)
- [Argo CD Documentation](https://argo-cd.readthedocs.io/)
- [Traefik Documentation](https://doc.traefik.io/traefik/)

---

# 🎓 Learning Objectives

Through this project, the following concepts are explored:

- 🖥️ Virtual machine creation and management.
- ☸️ Kubernetes cluster architecture.
- ⚙️ K3s installation and configuration.
- 🌐 Application deployment and Ingress routing.
- 🐳 Container management with Docker.
- 🧩 Kubernetes clusters with K3d.
- 🚀 Continuous deployment with Argo CD.
- 🔄 GitOps and automatic synchronization.
- 📄 Kubernetes YAML manifests.

---

# 👤 Author

<div align="center">

### tren-chvl

[![GitHub](https://img.shields.io/badge/GitHub-tren--chvl-181717?style=for-the-badge&logo=github)](https://github.com/tren-chvl)

**Inception of Things**

</div>

---

<div align="center">

```text
╔══════════════════════════════════════════════╗
║                                              ║
║          ☸️ INCEPTION OF THINGS ☸️           ║
║                                              ║
║       VAGRANT × K3S × K3D × ARGO CD          ║
║                                              ║
║           Kubernetes • DevOps • GitOps       ║
║                                              ║
╚══════════════════════════════════════════════╝
```


</div>