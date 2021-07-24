const FeedMContainers = {};
let MaxQueue = 5
let styled = false;


class NotificationContainer {
    constructor(position) {
        this.container = document.getElementById("feedm_container");
        this.el = document.createElement("div");
        this.el.classList.add("feedm-notification-container", `notification-container-${position}`);
        this.notifications = [];
        this.offset = 0;
        this.running = false;
        this.spacing = 10;
        this.queue = 0;
        this.maxQueue = MaxQueue;
    }

    addNotification(notification) {
        this.queue++;
        this.el.appendChild(notification.el);

        this.notifications.unshift(notification);
    }

    unqueueNotification() {
        this.queue--;
    }

    removeNotification(notification) {
        this.el.removeChild(notification.el);

        const index = this.notifications.indexOf(notification);

        if (index > -1) {
            this.notifications.splice(index, 1);
        }

        if (this.empty()) {
            this.remove();
        }
    }

    add() {
        if (!this.container.contains(this.el)) {
            this.container.appendChild(this.el);
        }
    }

    remove() {
        this.container.removeChild(this.el);
    }

    empty() {
        return this.el.children.length < 1;
    }
}

class Notification {
    show() {
        this.bottom = this.position.includes("bottom");

        if (this.position in FeedMContainers) {
            this.container = FeedMContainers[this.position];
        } else {
            this.container = new NotificationContainer(this.position);
            FeedMContainers[this.position] = this.container;
        }

        if (!this.container.running && this.container.queue < this.container.maxQueue) {

            this.container.add();

            this.container.addNotification(this);

            this.el.classList.add("active");

            if (this.bottom) {
                this.el.style.bottom = `${this.container.offset}px`;
            } else {
                this.el.style.top = `${this.container.offset}px`;
            }

            if (this.progress) {
                this.barEl.style.animationDuration = `${this.interval}ms`;
            }

            PostData("active")

            const r = this.el.getBoundingClientRect();

            for (const n of this.container.notifications) {
                if (n != this) {
                    if (this.bottom) {
                        n.moveUp(r.height, true);
                    } else {
                        n.moveDown(r.height, true);
                    }
                }
            }         

            setTimeout(() => {
                this.el.classList.remove("active");
                this.el.classList.add("hiding");

                this.container.unqueueNotification(this);

                setTimeout(() => {
                    const index = this.container.notifications.indexOf(this);

                    for (var i = this.container.notifications.length - 1; i > index; i--) {
                        const n = this.container.notifications[i];

                        if (this.bottom) {
                            n.moveDown(r.height);
                        } else {
                            n.moveUp(r.height);
                        }
                    }

                    setTimeout(() => {
                        this.container.removeNotification(this);
                    }, 100);
                }, this.cfg.FadeTime);
            }, this.interval);
        } else {
            setTimeout(() => {
                this.show();
            }, 250);
        }
    }

    moveUp(h, run = false) {
        if (this.bottom) {
            this.offset += (h + this.container.spacing);
        } else {
            this.offset -= (h + this.container.spacing);
        }
        this.el.style.transition = `transform 250ms ease 0ms`;
        this.el.style.transform = `translate3d(0px, ${-(h + this.container.spacing)}px, 0px)`;

        this.container.running = run;

        setTimeout(() => {
            if (run) {
                this.container.running = false;
            }
            this.el.style.transition = ``;
            this.el.style.transform = ``;
            if (this.bottom) {
                this.el.style.bottom = `${this.container.offset + this.offset}px`;
            } else {
                this.el.style.top = `${this.container.offset + this.offset}px`;
            }
        }, 250);
    }

    moveDown(h, run = false) {
        if (this.bottom) {
            this.offset -= (h + this.container.spacing);
        } else {
            this.offset += (h + this.container.spacing);
        }
        this.el.style.transition = `transform 250ms ease 0ms`;
        this.el.style.transform = `translate3d(0px, ${(h + this.container.spacing)}px, 0px)`;

        this.container.running = run;

        setTimeout(() => {
            if (run) {
                this.container.running = false;
            }
            this.el.style.transition = ``;
            this.el.style.transform = ``;

            if (this.bottom) {
                this.el.style.bottom = `${this.container.offset + this.offset}px`;
            } else {
                this.el.style.top = `${this.container.offset + this.offset}px`;
            }
        }, 250);
    }

    parseMessage(message, count = 4) {
        const regexColor = /~([^h])~([^~]+)/g;	
        const regexBold = /~([h])~([^~]+)/g;	
        const regexStop = /~s~/g;	
        const regexLine = /\n/g;	
    
        message = message.replace(regexColor, "<span class='$1'>$2</span>");
        message = message.replace(regexBold, "<span class='$1'>$2</span>");
        message = message.replace(regexStop, "");
        message = message.replace(regexLine, "<br />");
			
        return message;
    }
}

class StandardNotification extends Notification {
    constructor(cfg, message, interval, position, progress = false, theme = "default") {

        super();

        this.cfg = cfg;
        this.message = message;
        this.interval = interval;
        this.position = position;
        this.message = message;
        this.progress = progress;
        this.offset = 0;
        this.theme = theme;

        this.init();
    }

    init() {
        this.el = document.createElement("div");
        this.el.classList.add("feedm-notification");
        
        this.message = this.parseMessage(this.message);
        this.el.innerHTML = this.message;

        if ( this.theme ) {
            this.el.classList.add(this.theme);
        }        

        if (this.progress) {
            this.el.classList.add("with-progress");
            this.progressEl = document.createElement("div");
            this.progressEl.classList.add("notification-progress");

            this.barEl = document.createElement("div");
            this.barEl.classList.add("notification-bar");

            this.progressEl.appendChild(this.barEl);

            this.el.appendChild(this.progressEl);
        }
    }
}

class AdvancedNotification extends Notification {
    constructor(cfg, message, title, subject, icon, interval, position, progress = false, theme = "default") {

        super();

        this.cfg = cfg
        this.message = message;
        this.interval = interval;
        this.position = position;
        this.title = title;
        this.subject = subject;
        this.message = message;
        this.icon = icon;
        this.progress = progress;
        this.offset = 0;
        this.theme = theme;

        this.init();
    }

    init() {

        this.title = this.parseMessage(this.title);
        this.subject = this.parseMessage(this.subject);
        this.message = this.parseMessage(this.message);

        this.el = document.createElement("div");
        this.el.classList.add("feedm-notification");

        if ( this.theme ) {
            this.el.classList.add(this.theme);
        }

        this.headerEl = document.createElement("div");
        this.headerEl.classList.add("notification-header");

        this.iconEl = document.createElement("div");
        this.iconEl.classList.add("notification-icon");

        this.titleEl = document.createElement("div");
        this.titleEl.classList.add("notification-title");

        this.subjectEl = document.createElement("div");
        this.subjectEl.classList.add("notification-subject");

        this.messageEl = document.createElement("div");
        this.messageEl.classList.add("notification-message");


        this.iconEl.innerHTML = `<img src="images/${this.icon}" />`;
        this.titleEl.innerHTML = this.title;
        this.subjectEl.innerHTML = this.subject;
        this.messageEl.innerHTML = this.message;

        this.headerEl.appendChild(this.iconEl);
        this.headerEl.appendChild(this.titleEl);
        this.headerEl.appendChild(this.subjectEl);
        this.el.appendChild(this.headerEl);
        this.el.appendChild(this.messageEl);

        if (this.progress) {
            this.el.classList.add("with-progress");
            this.progressEl = document.createElement("div");
            this.progressEl.classList.add("notification-progress");

            this.barEl = document.createElement("div");
            this.barEl.classList.add("notification-bar");

            this.progressEl.appendChild(this.barEl);

            this.el.appendChild(this.progressEl);
        }
    }
}

function PostData(type = "", data = {}) {
    fetch(`https://${GetParentResourceName()}/bulletin_${type}`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify(data)
    }).then(resp => resp.json()).then(resp => resp).catch(error => console.log('bcbrp_shops FETCH ERROR! ' + error.message));    
}

const onData = function(e) {
    const data = e.data;
    if (data.type) {

        if ( !styled ) {
            const css = `
            .feedm-notification.active {
                opacity: 0;
                -webkit-animation: fadeIn ${data.config.FadeTime}ms ease 0ms forwards;
                animation: fadeIn ${data.config.FadeTime}ms ease 0ms forwards;
            }
            
            .feedm-notification.hiding {
                opacity: 1;
                -webkit-animation: fadeOut ${data.config.FadeTime}ms ease 0ms forwards;
                animation: fadeOut ${data.config.FadeTime}ms ease 0ms forwards;
            }`;

            document.head.insertAdjacentHTML("beforeend", `<style>${css}</style>`);

            styled = true
        }

        MaxQueue = data.config.Queue;
        if (data.type == "standard") {
            new StandardNotification(data.config, data.message, data.timeout, data.position, data.progress, data.theme).show();
        } else {
            new AdvancedNotification(data.config, data.message, data.title, data.subject, data.icon, data.timeout, data.position, data.progress, data.theme).show();
        }
    }
};

window.onload = function(e) {
    window.addEventListener('message', onData);
};