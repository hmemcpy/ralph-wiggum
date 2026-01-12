export function greet(name: string, formal?: boolean): string {
  if (formal) {
    return `Good day, ${name}.`;
  }
  return `Hello, ${name}!`;
}

export function greetByTime(name: string, hour: number): string {
  if (hour >= 5 && hour <= 11) {
    return `Good morning, ${name}`;
  } else if (hour >= 12 && hour <= 17) {
    return `Good afternoon, ${name}`;
  } else if (hour >= 18 && hour <= 21) {
    return `Good evening, ${name}`;
  } else {
    return `Good night, ${name}`;
  }
}
