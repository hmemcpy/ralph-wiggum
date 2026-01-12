export function greet(name: string, formal?: boolean): string {
  if (formal) {
    return `Good day, ${name}.`;
  }
  return `Hello, ${name}!`;
}
