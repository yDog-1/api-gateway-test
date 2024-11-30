import Link from "next/link";

export default function WelcomePage() {
	return (
		<main className="mx-auto container h-screen content-center">
			<div className="flex m-auto items-center flex-col">
				<h1>Welcome to the API Gateway Test!</h1>
				<span>
					You can go back to the{" "}
					<Link
						href={"/"}
						className="text-blue-500 bg-white rounded-sm px-1 hover:underline hover:underline-offset-1 hover:decoration-blue-500"
					>
						home page
					</Link>
				</span>
			</div>
		</main>
	);
}
