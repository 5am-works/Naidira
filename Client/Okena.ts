class Okena {
    private static desegniloj: Map<string, (ctx: CanvasRenderingContext2D, turni: boolean, longeco: number) => void> = new Map([
        ["_", (ctx, turni, longeco) => {
            ctx.beginPath();
            ctx.moveTo(0, longeco * 0.6);
            ctx.lineTo(0, 0);
            ctx.lineTo(longeco, 0);
            ctx.stroke();
        }],
        ["m", (ctx, turni, longeco) => {
            ctx.beginPath();
            ctx.moveTo(0, longeco * 0.3);
            ctx.lineTo(0, longeco * 0.7);
            ctx.ellipse(longeco * 0.5, longeco * 0.7, longeco / 2, longeco * 0.3 + 1, 0, Math.PI, 2 * Math.PI, true);
            ctx.lineTo(longeco, 0);
            ctx.stroke();
        }],
        ["b", (ctx, turni, longeco) => {
            ctx.beginPath();
            ctx.moveTo(0, longeco * 0.3);
            ctx.lineTo(0, longeco);
            ctx.lineTo(longeco, longeco);
            ctx.lineTo(longeco, 0);
            ctx.moveTo(longeco * 0.75, 0);
            ctx.lineTo(longeco * 0.75, longeco);
            ctx.stroke();
        }],
        ["p", (ctx, turni, longeco) => {
            ctx.beginPath();
            ctx.moveTo(0, longeco * 0.3);
            ctx.lineTo(0, longeco);
            ctx.lineTo(longeco, longeco);
            ctx.lineTo(longeco, 0);
            ctx.stroke();
        }],
        ["v", (ctx, turni, longeco) => {
            ctx.beginPath();
            ctx.moveTo(0, 0);
            ctx.lineTo(longeco, 0);
            ctx.moveTo(0, longeco * 0.6);
            ctx.lineTo(0, longeco);
            ctx.lineTo(longeco, longeco);
            ctx.lineTo(longeco, longeco * 0.3);
            ctx.lineTo(longeco * 0.65, longeco * 0.3);
            ctx.moveTo(longeco * 0.75, longeco);
            ctx.lineTo(longeco * 0.75, longeco * 0.3);
            ctx.stroke();
        }],
        ["f", (ctx, turni, longeco) => {
            ctx.beginPath();
            ctx.moveTo(0, 0);
            ctx.lineTo(longeco, 0);
            ctx.moveTo(0, longeco * 0.6);
            ctx.lineTo(0, longeco);
            ctx.lineTo(longeco, longeco);
            ctx.lineTo(longeco, longeco * 0.3);
            ctx.lineTo(longeco * 0.85, longeco * 0.3);
            ctx.stroke();
        }],
        ["n", (ctx, turni, longeco) => {
            ctx.beginPath();
            ctx.moveTo(0, longeco * 0.6);
            ctx.lineTo(0, longeco * 0.3);
            ctx.ellipse(longeco * 0.5, longeco * 0.3, longeco / 2, longeco * 0.3 + 1, 0, Math.PI, 0);
            ctx.lineTo(longeco, longeco)
            ctx.stroke();
        }],
        ["d", (ctx, turni, longeco) => {
            ctx.beginPath();
            ctx.moveTo(0, longeco * 0.6);
            ctx.lineTo(0, 0);
            ctx.lineTo(longeco, 0);
            ctx.lineTo(longeco, longeco);
            ctx.moveTo(longeco * 0.75, 0);
            ctx.lineTo(longeco * 0.75, longeco);
            ctx.stroke();
        }],
        ["t", (ctx, turni, longeco) => {
            ctx.beginPath();
            ctx.moveTo(0, longeco * 0.6);
            ctx.lineTo(0, 0);
            ctx.lineTo(longeco, 0);
            ctx.lineTo(longeco, longeco);
            ctx.stroke();
        }],
        ["z", (ctx, turni, longeco) => {
            ctx.beginPath();
            ctx.moveTo(0, 0);
            ctx.lineTo(longeco, 0);
            ctx.moveTo(0, longeco * 0.6);
            ctx.lineTo(0, longeco * 0.3);
            ctx.lineTo(longeco, longeco * 0.3);
            ctx.lineTo(longeco, longeco);
            ctx.moveTo(longeco * 0.75, longeco * 0.3);
            ctx.lineTo(longeco * 0.75, longeco);
            ctx.stroke();
        }],
        ["s", (ctx, turni, longeco) => {
            ctx.beginPath();
            ctx.moveTo(0, 0);
            ctx.lineTo(longeco, 0);
            ctx.moveTo(0, longeco * 0.6);
            ctx.lineTo(0, longeco * 0.3);
            ctx.lineTo(longeco, longeco * 0.3);
            ctx.lineTo(longeco, longeco);
            ctx.stroke();
        }],
        ["l", (ctx, turni, longeco) => {
            ctx.beginPath();
            ctx.moveTo(0, 0);
            ctx.lineTo(0, longeco);
            ctx.lineTo(longeco, longeco);
            ctx.lineTo(longeco, 0);
            ctx.moveTo(longeco * 0.3, longeco);
            ctx.lineTo(longeco * 0.3, longeco * 0.4);
            ctx.stroke();
        }],
        ["r", (ctx, turni, longeco) => {
            ctx.save();
            ctx.beginPath();
            ctx.rect(-ctx.lineWidth / 2, -ctx.lineWidth / 2, longeco + ctx.lineWidth, longeco + ctx.lineWidth);
            ctx.clip();
            ctx.beginPath();
            ctx.moveTo(0, longeco * 0.6);
            ctx.lineTo(0, 0);
            ctx.lineTo(longeco, longeco);
            ctx.lineTo(longeco, 0);
            ctx.stroke();
            ctx.restore();
        }],
        ["ʃ", (ctx, turni, longeco) => {
            ctx.beginPath();
            ctx.moveTo(0, 0);
            ctx.lineTo(longeco, 0);
            ctx.moveTo(0, longeco * 0.6);
            ctx.lineTo(0, longeco * 0.3);
            ctx.lineTo(longeco, longeco * 0.3);
            ctx.lineTo(longeco, longeco);
            ctx.lineTo(longeco * 0.85, longeco);
            ctx.stroke();
        }],
        ["j", (ctx, turni, longeco) => {
            ctx.beginPath();
            ctx.moveTo(0, longeco);
            ctx.lineTo(longeco / 2, 0);
            ctx.lineTo(longeco, longeco);
            ctx.moveTo(longeco / 2, 0);
            ctx.lineTo(longeco / 2, longeco * 0.6);
            ctx.stroke();
        }],
        ["g", (ctx, turni, longeco) => {
            ctx.beginPath();
            ctx.moveTo(0, longeco * 0.6);
            ctx.lineTo(0, 0)
            ctx.lineTo(longeco, 0);
            ctx.lineTo(longeco * 0.85, longeco / 2);
            ctx.lineTo(longeco, longeco);
            ctx.moveTo(longeco * 0.7, 0);
            ctx.lineTo(longeco * 0.55, longeco / 2);
            ctx.lineTo(longeco * 0.7, longeco);
            ctx.stroke();
        }],
        ["k", (ctx, turni, longeco) => {
            ctx.beginPath();
            ctx.moveTo(0, longeco * 0.6);
            ctx.lineTo(0, 0)
            ctx.lineTo(longeco, 0);
            ctx.lineTo(longeco * 0.7, longeco / 2);
            ctx.lineTo(longeco, longeco);
            ctx.stroke();
        }],
        ["w", (ctx, turni, longeco) => {
            ctx.beginPath();
            ctx.moveTo(0, 0);
            ctx.lineTo(0, longeco * 0.6);
            ctx.moveTo(longeco, 0);
            ctx.lineTo(3, longeco / 2);
            ctx.lineTo(longeco, longeco);
            ctx.stroke();
        }],
        // Vokaloj
        ["a", (ctx, turni, longeco) => {
            ctx.beginPath();
            ctx.moveTo(0, longeco * 0.6 - 2);
            ctx.ellipse(longeco * 0.2, longeco * 0.8 + 1, longeco * 0.2, longeco * 0.2, 0, Math.PI, 2 * Math.PI - 1.7, true);
            ctx.stroke();
        }],
        ["e", (ctx, turni, longeco) => {
            ctx.beginPath();
            ctx.moveTo(0, longeco * 0.6);
            ctx.ellipse(longeco * 0.2, longeco * 0.8 + 1, longeco * 0.2, longeco * 0.2, 0, Math.PI, 2 * Math.PI, true);
            ctx.stroke();
        }],
        ["i", (ctx, turni, longeco) => {
            ctx.beginPath();
            ctx.moveTo(0, longeco * 0.6);
            ctx.ellipse(longeco * 0.2, longeco * 0.8 + (turni ? -2 : 1), longeco * 0.2, longeco * 0.2, 0, Math.PI, 2 * Math.PI, true);
            ctx.stroke();
            ctx.beginPath();
            ctx.moveTo(longeco * 0.4, longeco * 0.7);
            ctx.lineTo(longeco * 0.4, longeco + (turni ? 0 : 2));
            ctx.stroke();
        }],
        ["A", (ctx, turni, longeco) => {
            ctx.beginPath();
            ctx.moveTo(0, longeco * 0.6 - 2);
            ctx.ellipse(longeco * 0.2, longeco * 0.8 + (turni ? -2 : 1), longeco * 0.2, longeco * 0.2, 0, Math.PI, 2 * Math.PI - 1.7, true);
            ctx.stroke();

            ctx.beginPath();
            ctx.moveTo(longeco * 0.4, longeco * 0.8);
            ctx.lineTo(longeco * 0.4, longeco + (turni ? 0 : 2));
            ctx.stroke();
        }],
        ["E", (ctx, turni, longeco) => {
            ctx.beginPath();
            ctx.moveTo(0, longeco * 0.6);
            ctx.ellipse(longeco * 0.2 - 1, longeco * 0.8 + (turni ? -2 : 1), longeco * 0.2 - 1, longeco * 0.2, 0, Math.PI, 2 * Math.PI, true);
            ctx.stroke();
            ctx.beginPath();
            ctx.moveTo(longeco * 0.4 - 2, longeco * 0.7 + 1);
            ctx.lineTo(longeco * 0.4 - 2, longeco + (turni ? 0 : 2));
            ctx.moveTo(longeco * 0.4 + 2, longeco * 0.7 + 1);
            ctx.lineTo(longeco * 0.4 + 2, longeco + (turni ? 0 : 2));
            ctx.stroke();
        }],
        ["U", (ctx, turni, longeco) => {
            ctx.beginPath();
            ctx.moveTo(0, longeco * 0.6 - 2);
            ctx.ellipse(longeco * 0.2, longeco * 0.8 + (turni ? -2 : 1), longeco * 0.2, longeco * 0.2, 0, Math.PI, 2 * Math.PI - 1.7, true);
            ctx.stroke();
            ctx.beginPath();
            ctx.moveTo(3, longeco * 0.75 - 2);
            ctx.lineTo(longeco * 0.4 + 2, longeco * 0.75 - 2);
            ctx.stroke();
        }],
    ]);
    private static vokaloMoviloj: Map<string, (ctx: CanvasRenderingContext2D, longeco: number) => void> = new Map([
        ["m", Okena.mbpMovi],
        ["b", Okena.mbpMovi],
        ["p", Okena.mbpMovi],
        ["v", Okena.vfMovi],
        ["f", Okena.vfMovi],
        ["l", (ctx, longeco) => {
            ctx.transform(1, 0, 0, -1, 0, longeco);
            ctx.transform(1, 0, 0, 1, longeco * 0.3, 0);
        }],
        ["j", (ctx, longeco) => {
            ctx.transform(1, 0, 0, 1, longeco * 0.5, 0);
        }],
    ]);
    private static mallumajVokaloj = new Map<string, string>([
        ['ɔ', 'a'],
        ['o', 'e'],
        ['u', 'i'],
        ['O', 'E'],
        ['U', 'U'],
    ]);

    constructor() {
    }

    desegni(eniro: string, ctx: CanvasRenderingContext2D, longeco: number, spaco: number) {
        let turni = false;
        eniro.split("\n").forEach((vico, v) => {
            ctx.setTransform(1, 0, 0, 1, 0, 0);
            ctx.transform(1, 0, 0, 1, spaco, (v + 1) * spaco * 2 + v * longeco);
            vico.split(" ").forEach((vorto) => {
                if (vorto.length > 0) {
                    if (turni) {
                        ctx.transform(0, -1, 1, 0, 0, longeco);
                    }
                    [...vorto].forEach((litero, indekso) => {
                        if (indekso % 2 === 0) { // Konsonanto
                            const vokalo = vorto.charAt(indekso + 1);
                            if (Okena.mallumajVokaloj.has(vokalo)) {
                                ctx.save();
                                if (litero === 'r') {
                                    ctx.transform(-1, 0, 0, -1, longeco, longeco);
                                } else {
                                    ctx.transform(-1, 0, 0, 1, longeco, 0);
                                }
                            }
                            const desegnilo = Okena.desegniloj.get(litero);
                            if (desegnilo) {
                                desegnilo(ctx, turni, longeco);
                            }
                        } else { // Vokalo
                            ctx.save();
                            const konsonanto = vorto.charAt(indekso - 1);
                            const vm = Okena.vokaloMoviloj.get(konsonanto);
                            if (vm != null) {
                                vm(ctx, longeco);
                            }
                            const desegnilo = Okena.desegniloj.get(Okena.mallumajVokaloj.get(litero) || litero);
                            if (desegnilo != null) {
                                desegnilo(ctx, turni, longeco);
                            } else {
                                console.error(`Nekonita litero: ${litero}`);
                            }
                            ctx.restore();
                            ctx.restore();
                            if (turni) {
                                ctx.transform(1, 0, 0, 1, 0, longeco + spaco);
                            } else {
                                ctx.transform(1, 0, 0, 1, longeco + spaco, 0);
                            }
                        }
                    });
                    turni = !turni;
                    if (!turni) {
                        ctx.transform(0, 1, -1, 0, 0, 0);
                        ctx.transform(1, 0, 0, 1, 0, -longeco);
                    }
                }
            });
        });
    }

    private static mbpMovi(ctx: CanvasRenderingContext2D, longeco: number) {
        ctx.transform(1, 0, 0, -1, 0, longeco);
    }

    private static vfMovi(ctx: CanvasRenderingContext2D, longeco: number) {
        ctx.transform(1, 0, 0, -1, 0, longeco);
        ctx.transform(1, 0, 0, 1, 0, -longeco * 0.3);
    }
}

const okena = new Okena();

export function drawText(text: string, canvas: HTMLCanvasElement, longeco: number) {
    const ctx = canvas.getContext("2d");
    const spaco = 4;
    if (ctx != null) {
        ctx.setTransform(1, 0, 0, 1, 0, 0);
        ctx.clearRect(0, 0, canvas.width, canvas.height);
        ctx.lineWidth = 2.5;
        ctx.strokeStyle = "#e0e6f8";
        ctx.lineCap = 'round';
        okena.desegni(text, ctx, longeco - 20, spaco);
    }
}