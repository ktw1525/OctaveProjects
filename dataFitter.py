import tkinter as tk
from tkinter import messagebox
import numpy as np

def parse_input(text):
    try:
        data = []
        for line in text.strip().split('\n'):
            data.append([float(x) for x in line.split()])
        return np.array(data)
    except ValueError:
        messagebox.showerror("Input Error", "Invalid input format.")
        return None

def compute_ab(X_data, Y_data):
    X = np.vstack(X_data)
    Y = np.vstack(Y_data)
    k, n = X.shape

    X_stacked = np.hstack([X, np.ones((k, 1))])
    A_b, _, _, _ = np.linalg.lstsq(X_stacked, Y, rcond=None)

    A = A_b[:-1].T
    b = A_b[-1]

    return A, b

def on_calculate():
    X_text = X_entry.get("1.0", tk.END)
    Y_text = Y_entry.get("1.0", tk.END)

    X_data = parse_input(X_text)
    Y_data = parse_input(Y_text)

    if X_data is None or Y_data is None:
        return

    if X_data.shape != Y_data.shape:
        messagebox.showerror("Input Error", "X and Y must have the same dimensions.")
        return

    A, b = compute_ab(X_data, Y_data)

    A_output.delete("1.0", tk.END)
    b_output.delete("1.0", tk.END)

    A_output.insert(tk.END, np.array2string(A, precision=4, separator=', '))
    b_output.insert(tk.END, np.array2string(b, precision=4, separator=', '))

    # 오차율 계산
    Y_pred = np.dot(X_data, A.T) + b
    error_rate = np.mean(np.abs((Y_pred - Y_data) / Y_data)) * 100

    error_output.delete("1.0", tk.END)
    error_output.insert(tk.END, f"{error_rate:.4f}%")

def on_validate():
    X_val_text = X_val_entry.get("1.0", tk.END)
    X_val_data = parse_input(X_val_text)

    if X_val_data is None:
        return

    A_text = A_output.get("1.0", tk.END)
    b_text = b_output.get("1.0", tk.END)

    try:
        A = np.array(eval(A_text))
        b = np.array(eval(b_text))
    except Exception as e:
        messagebox.showerror("Validation Error", f"Invalid A or b format.\n{e}")
        return

    Y_val_pred = np.dot(X_val_data, A.T) + b
    validation_output.delete("1.0", tk.END)
    validation_output.insert(tk.END, np.array2string(Y_val_pred, precision=4, separator=', '))

# GUI Setup
root = tk.Tk()
root.title("Linear Relationship Solver")

tk.Label(root, text="Input X (one vector per line, space-separated):").grid(row=0, column=0)
X_entry = tk.Text(root, height=10, width=50)
X_entry.grid(row=1, column=0)

tk.Label(root, text="Input Y (one vector per line, space-separated):").grid(row=0, column=1)
Y_entry = tk.Text(root, height=10, width=50)
Y_entry.grid(row=1, column=1)

calculate_button = tk.Button(root, text="Calculate", command=on_calculate)
calculate_button.grid(row=2, column=0, columnspan=2)

tk.Label(root, text="Resulting A matrix:").grid(row=3, column=0)
A_output = tk.Text(root, height=10, width=50)
A_output.grid(row=4, column=0)

tk.Label(root, text="Resulting b vector:").grid(row=3, column=1)
b_output = tk.Text(root, height=10, width=50)
b_output.grid(row=4, column=1)

tk.Label(root, text="Error Rate:").grid(row=5, column=0)
error_output = tk.Text(root, height=1, width=50)
error_output.grid(row=6, column=0)

tk.Label(root, text="Validation Input X (one vector per line, space-separated):").grid(row=7, column=0)
X_val_entry = tk.Text(root, height=10, width=50)
X_val_entry.grid(row=8, column=0)

validate_button = tk.Button(root, text="Validate", command=on_validate)
validate_button.grid(row=9, column=0, columnspan=2)

tk.Label(root, text="Validation Output Y:").grid(row=7, column=1)
validation_output = tk.Text(root, height=10, width=50)
validation_output.grid(row=8, column=1)

root.mainloop()
