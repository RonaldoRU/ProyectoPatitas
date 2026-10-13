import type { InputHTMLAttributes } from 'react';

type InputFieldProps = {
    id: string;
    label: string;
    value: string;
    onChange: (value: string) => void;
} & Omit<InputHTMLAttributes<HTMLInputElement>, 'id' | 'value' | 'onChange'>;

export default function InputField({
    id,
    label,
    value,
    onChange,
    ...inputProps
}: InputFieldProps) {
    return (
        <div className="field">
            <label htmlFor={id}>{label}</label>
            <input
                {...inputProps}
                id={id}
                value={value}
                onChange={(event) => onChange(event.target.value)}
            />
        </div>
    );
}